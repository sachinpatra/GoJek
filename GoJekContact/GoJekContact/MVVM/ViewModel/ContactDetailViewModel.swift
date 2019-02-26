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
        let messageAction: Driver<Void>
        let callAction: Driver<Void>
        let emailAction: Driver<Void>
    }
    
    struct Output {
        let fetchedContact: Driver<Contact>
        let favourite: Driver<Void>
        let deleteContact: Driver<Void>
        let contact: Driver<Contact>
        let error: Driver<Error>
        let message: Driver<String>
        let call: Driver<String>
        let email: Driver<String>
        let editing: Driver<Void>
    }
}

final class ContactDetailViewModel: ViewModelType {
    private var contact: Contact
    private let useCase: ContactUseCase
    private let navigator: DefaultContactsNavigator
    
    init(contact: Contact, useCase: ContactUseCase, navigator: DefaultContactsNavigator) {
        self.contact = contact
        self.useCase = useCase
        self.navigator = navigator
    }

    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let contact = Driver.just(self.contact)
        
        let fetchedContact = input.fetchContactAction.flatMapLatest {_ in
            return self.useCase.contact(contactId: self.contact.uid)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map({ (fetchContact) -> Contact in
                    self.contact.email = fetchContact.email
                    self.contact.phoneNumber = fetchContact.phoneNumber
                    return fetchContact
                })
        }
        
        let editing = input.editAction
            .map({ return self.navigator.toEditContact(self.contact) })
        let message = input.messageAction
            .map({ return self.contact.phoneNumber })
        let call = input.callAction
            .map({ return self.contact.phoneNumber })
        let email = input.emailAction
            .map({ return self.contact.email })
        
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
                    fetchedContact: fetchedContact,
                    favourite: favourite,
                      deleteContact: deleteContact,
                      contact: contact,
                      error: errorTracker.asDriver(),
                      message: message,
                      call: call,
                      email: email,
                      editing: editing)
    }
}
