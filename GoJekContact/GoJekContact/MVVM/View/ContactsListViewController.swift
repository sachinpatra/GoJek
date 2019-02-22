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
import Alamofire

class ContactsListViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactButton: UIBarButtonItem!
    var viewModel: ContactsListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()

//        // MARK: - Binding ViewModel
//        viewModel.viewModelData
//            .bind(to: tableView.rx.items(dataSource: tableViewDataSourceUI()))
//            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
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
        output.contacts.drive(tableView.rx.items(cellIdentifier: ContactListCell.reuseIdentifier, cellType: ContactListCell.self)){ table, viewModel, cell in
            cell.configure(viewModel)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func addContactAction(_ sender: UIBarButtonItem) {
        Alamofire.request(Constants.BASE_URL + "contacts.json",
                          method: .get).validate().responseJSON(queue: DispatchQueue(label: "Manage User Contact", qos: .background)) { (response) in
                            
            //Handle Error
            guard let responseDics = Utility.handleserviceError(response: response) else { return }

                print("\(responseDics)")
        }
    }
    
}

//extension ContactsListViewController {
//    func tableViewDataSourceUI() -> RxTableViewSectionedAnimatedDataSource<ContactListSectionModel> {
//        return RxTableViewSectionedAnimatedDataSource<ContactListSectionModel>(
//            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .top),
//            configureCell: { (dataSource, table, indexPath, item) in
//                let tryMakingCell: () -> UITableViewCell? = {
//                    switch item {
//                    case .ContactRow(id: _, contact: _):
//                        let cell: ContactListCell = table.dequeueReusableCell(forIndexPath: indexPath)
//                        //cell.favouriteStatusImage.isHidden = true
//                        return cell
//                    }
//                }
//                return tryMakingCell() ?? UITableViewCell()
//        })
//    }
//}

class ContactListCell: UITableViewCell {
    
    @IBOutlet weak var favouriteStatusImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    func configure(_ viewModel: Contact) {
        self.contactName.text = viewModel.firstName + viewModel.lastName
    }
}