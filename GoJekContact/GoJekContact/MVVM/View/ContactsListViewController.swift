//
//  ContactsListViewController.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import Kingfisher

class ContactsListViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactButton: UIBarButtonItem!
    var viewModel: ContactsListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
    
        let input = ContactsListViewModel.Input(fetchAllContactsAction: Driver.merge(viewWillAppear, pull),
                                         createContactAction: addContactButton.rx.tap.asDriver(),
                                         selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.contacts.drive(BehaviorRelay<[Contact]>(value: [])).disposed(by: disposeBag)
        output.animateContacts
                    .bind(to: tableView.rx.items(dataSource: tableViewDataSourceUI()))
                    .disposed(by: disposeBag)
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.selectedContact
            .drive()
            .disposed(by: disposeBag)
        output.createContact
            .drive()
            .disposed(by: disposeBag)
    }
}

extension ContactsListViewController {
    func tableViewDataSourceUI() -> RxTableViewSectionedAnimatedDataSource<ContactListSectionModel> {
        return RxTableViewSectionedAnimatedDataSource<ContactListSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .top),
            configureCell: { (dataSource, table, indexPath, item) in
                let tryMakingCell: () -> UITableViewCell? = {
                    switch item {
                    case .ContactRow(contact: let contact):
                        let cell: ContactListCell = table.dequeueReusableCell(forIndexPath: indexPath)
                        cell.configure(contact)
                        return cell
                    }
                }
                return tryMakingCell() ?? UITableViewCell()
        }, titleForHeaderInSection: {(dataSource, section) in
            return dataSource[section].identity.uppercased()
        })
    }
}

class ContactListCell: UITableViewCell {
    
    @IBOutlet weak var favouriteStatusImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    func configure(_ viewModel: Contact) {
//        let imageURL = URL(string: Constants.BASE_URL+viewModel.profilePic)
//        contactImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "placeholder"))
        
        self.contactName.text =  viewModel.firstName.capitalizingFirstLetter() + "  " + viewModel.lastName.capitalizingFirstLetter()
        favouriteStatusImage.isHidden = !viewModel.favourite
    }
}
