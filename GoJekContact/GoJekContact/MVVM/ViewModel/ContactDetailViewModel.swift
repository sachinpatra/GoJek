//
//  ContactDetailViewModel.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/24/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import RxCocoa

extension ContactDetailViewModel {
    struct Input {
        let editAction: Driver<Void>
        let fetchContactAction: Driver<Void>
        let favouriteAction: Driver<Void>

    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let fetchedContact: Driver<Contact>
        let favourite: Driver<Void>
        let deleteContact: Driver<Void>
        let editing: Driver<Bool>
        let contact: Driver<Contact>
        let error: Driver<Error>
    }
}

final class ContactDetailViewModel: ViewModelType {
    private let contact: Contact
    private let useCase: ContactUseCase
    private let navigator: DefaultDetailContactNavigator
    
    init(contact: Contact, useCase: ContactUseCase, navigator: DefaultDetailContactNavigator) {
        self.contact = contact
        self.useCase = useCase
        self.navigator = navigator
    }

    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let editing = input.editAction.scan(false) { editing, _ in
            return !editing
            }.startWith(false)
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "Done" : "Edit"
        }
        let contact = Driver.just(self.contact)
        
        let fetchedContact = input.fetchContactAction.flatMapLatest {_ in
            return self.useCase.contact(contactId: self.contact.uid)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let favourite = input.favouriteAction.withLatestFrom(contact)
            .map { (contact) in
                return Contact(firstName: contact.firstName, lastName: contact.lastName, email: contact.email, phoneNumber: contact.phoneNumber, detailURL: contact.detailURL, uid: contact.uid, profilePic: contact.profilePic, favourite: !contact.favourite)
            }.flatMapLatest { [unowned self] in
                return self.useCase.update(contact: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        
       let deleteContact = self.useCase.delete(contact: self.contact)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete().asDriver()
        
        
        return Output(
                    editButtonTitle: editButtonTitle,
                    fetchedContact: fetchedContact,
                    favourite: favourite,
//                      save: savePost,
                      deleteContact: deleteContact,
                      editing: editing,
                      contact: contact,
                      error: errorTracker.asDriver())
    }
}
