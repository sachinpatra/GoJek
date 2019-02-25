//
//  ContactsListViewModel.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import UIKit
import RxSwift

extension ContactsListViewModel {
    struct Input {
        let fetchAllContactsAction: Driver<Void>
        let createContactAction: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let contacts: Driver<[Contact]>
        let animateContacts: BehaviorRelay<[ContactListSectionModel]>
        let createContact: Driver<Void>
        let selectedContact: Driver<Contact>
        let error: Driver<Error>
    }
}

final class ContactsListViewModel: ViewModelType {
//    var viewModelData: BehaviorRelay<[ContactListSectionModel]> {
//        return BehaviorRelay<[ContactListSectionModel]>(value: [.ContactListSection(header: "Hello",
//                                                                                    items: [.ContactRow(id: 1, contact: Contact())])])
//    }

    private let useCase: ContactUseCase
    private let navigator: ContactsNavigator

    init(useCase: ContactUseCase, navigator: ContactsNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let animateContacts = BehaviorRelay<[ContactListSectionModel]>(value: [])

//        let contacts = input.fetchAllContactsAction.flatMapLatest {
//            return self.useCase.contacts()
//                .trackActivity(activityIndicator)
//                .trackError(errorTracker)
//                .asDriverOnErrorJustComplete()
//                //.map { $0.map { PostItemViewModel(with: $0) } }
//        }
        
        let contacts = input.fetchAllContactsAction.flatMapLatest {_ in
            return self.useCase.contacts()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map({ (contacts) -> ([Contact]) in
                    var arrangedList = [ContactListSectionModel]()
                    for value in UnicodeScalar("a").value...UnicodeScalar("z").value {
                        let filteredOnChar = contacts.filter {
                            $0.firstName.hasPrefix("\(UnicodeScalar(value)!)")
                            }.map { (contact) -> ContactListSectionItem in
                              return .ContactRow(contact: contact)
                        }
                        arrangedList.append(.ContactListSection(header: "\(UnicodeScalar(value)!)", items: filteredOnChar))
                    }
                    animateContacts.accept(arrangedList)
                    return contacts
                })
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedContact = input.selection
            .withLatestFrom(contacts) { (indexPath, contacts) -> Contact in
                switch  animateContacts.value[indexPath.section].items[indexPath.row] {
                case .ContactRow(contact: let contact):
                    return contact
                        //self.useCase.contact(contactId: contact.uid)
                }
            }.do(onNext: navigator.toContact)
        
        let createContact = input.createContactAction
            .do(onNext: navigator.toCreateContact)
        
        return Output(fetching: fetching,
                      contacts: contacts,
                      animateContacts: animateContacts,
                      createContact: createContact,
                      selectedContact: selectedContact,
                      error: errors)
    }
}
