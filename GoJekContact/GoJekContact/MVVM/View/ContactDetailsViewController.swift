//
//  ContactDetailsViewController.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/24/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MessageUI

class ContactDetailsViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    private let disposeBag = DisposeBag()
    var viewModel: ContactDetailViewModel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    var tableData: BehaviorRelay<[ContactDetailSection]> = BehaviorRelay<[ContactDetailSection]>(value: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        tableView.refreshControl = UIRefreshControl()
        tableView.beginRefreshing()
        editButton.isEnabled = false

        bindViewModel()
        
    }

    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = ContactDetailViewModel.Input(editAction: editButton.rx.tap.asDriver(),
                                                 fetchContactAction: viewWillAppear.asDriver(),
                                                 favouriteAction: favouriteButton.rx.tap.asDriver(),
                                                 messageAction: messageButton.rx.tap.asDriver(),
                                                 callAction: callButton.rx.tap.asDriver(),
                                                 emailAction: emailButton.rx.tap.asDriver())
        
        
        let output = viewModel.transform(input: input)
        
        [
         output.contact.drive(contactBinding),
         output.fetchedContact.drive(fetchedContactBinding),
         output.editing.drive(),
         output.favourite.drive(),
         output.message.drive(messageBinding),
         output.call.drive(callBinding),
         output.email.drive(emailBinding)
        ].forEach({$0.disposed(by: disposeBag)})
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 1 && indexPath.row == 0 {
                    output.deleteContact.drive()
                    .disposed(by: self.disposeBag)
                    
                    let alertController = UIAlertController(title: "GoJek", message: "Contact Deleted", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alertController, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        tableData.bind(to: tableView.rx.items(dataSource: tableViewDataSourceUI())).disposed(by: disposeBag)
    }
    
    var callBinding: Binder<String> {
        return Binder(self, binding: { (vc, phoneNumber) in
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
    }
    
    var emailBinding: Binder<String> {
        return Binder(self, binding: { (vc, email) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([email])
                vc.present(mail, animated: true)
            }
        })
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    var messageBinding: Binder<String> {
        return Binder(self, binding: { (vc, phoneNumber) in
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                controller.body = ""
                controller.recipients = [phoneNumber]
                controller.messageComposeDelegate = self
                vc.present(controller, animated: true, completion: nil)
            }
        })
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var contactBinding: Binder<Contact> {
        return Binder(self, binding: { (vc, contact) in
            let imageURL = URL(string: Constants.BASE_URL+contact.profilePic)
            vc.profileImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "placeholder"))
            vc.favouriteButton.setImage(contact.favourite ? #imageLiteral(resourceName: "favourite_select") : #imageLiteral(resourceName: "favourite_unselect"), for: .normal)
            vc.nameLabel.text = contact.firstName.capitalizingFirstLetter() + "  " + contact.lastName.capitalizingFirstLetter()
        })
    }
    var fetchedContactBinding: Binder<Contact> {
        return Binder(self, binding: { (vc, contact) in
            vc.tableView.refreshControl?.endRefreshing()
            vc.tableView.refreshControl?.removeFromSuperview()
            vc.editButton.isEnabled = true
            vc.messageButton.isEnabled = true
            vc.callButton.isEnabled = true
            vc.emailButton.isEnabled = true
            vc.favouriteButton.isEnabled = true

            let sections = [
                ContactDetailSection(header: "1St", items: [ContactDetailRow(title: "mobile", detail: contact.phoneNumber),
                                                            ContactDetailRow(title: "email", detail: contact.email)]),
                ContactDetailSection(header: "Delete Cell", items: [ContactDetailRow(title: "Temp Title", detail: "Temp Ddetail")])
            ]
            vc.tableData.accept(sections)
        })
    }
}

extension ContactDetailsViewController {
    func tableViewDataSourceUI() -> RxTableViewSectionedAnimatedDataSource<ContactDetailSection> {
        return RxTableViewSectionedAnimatedDataSource<ContactDetailSection>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade),
            configureCell: { (dataSource, table, indexPath, item) in
                let tryMakingCell: () -> UITableViewCell? = {
                    if indexPath.section == 1 {
                        let cell = table.dequeueReusableCell(withIdentifier: "deleteCell")
                        return cell
                    } else {
                        let cell: ContactDetailCell = table.dequeueReusableCell(forIndexPath: indexPath)
                        cell.title.text = item.title
                        cell.detailTextField.text = item.detail
                        return cell
                    }
                }
                return tryMakingCell() ?? UITableViewCell()
        })
    }
}

class ContactDetailCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
}
