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

final class ContactsListViewModel: ViewModelType {
//    var viewModelData: BehaviorRelay<[ContactListSectionModel]> {
//        return BehaviorRelay<[ContactListSectionModel]>(value: [.ContactListSection(header: "Hello",
//                                                                                    items: [.ContactRow(id: 1, contact: Contact())])])
//    }
    
    struct Input {
        let fetchAllContactsAction: Driver<Void>
        let createContactAction: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let contacts: Driver<[Contact]>
        let createContact: Driver<Void>
        let selectedContact: Driver<Contact>
        let error: Driver<Error>
    }

    private let useCase: ContactUseCase
    private let navigator: ContactsNavigator
    
    init(useCase: ContactUseCase, navigator: ContactsNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let contacts = input.fetchAllContactsAction.flatMapLatest {
            return self.useCase.contacts()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                //.map { $0.map { PostItemViewModel(with: $0) } }
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedContact = input.selection
            .withLatestFrom(contacts) { (indexPath, contacts) -> Contact in
                return contacts[indexPath.row]
            }.do(onNext: navigator.toContact)
        
        let createContact = input.createContactAction
            .do(onNext: navigator.toCreateContact)
        
        return Output(fetching: fetching,
                      contacts: contacts,
                      createContact: createContact,
                      selectedContact: selectedContact,
                      error: errors)
    }
}
