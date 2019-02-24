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

class ContactDetailsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: ContactDetailViewModel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white

        bindViewModel()

        
    }

    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = ContactDetailViewModel.Input(editAction: editButton.rx.tap.asDriver(),
                                                 fetchContactAction: viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.editButtonTitle.drive(editButton.rx.title),
         output.contact.drive(contactBinding),
         output.fetchedContact.drive(fetchedContactBinding)
            ].forEach({$0.disposed(by: disposeBag)})
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
            print("")
        })
    }
}
