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

        //        let deleteTrigger: Driver<Void>
        //        let title: Driver<String>
        //        let details: Driver<String>
    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let fetchedContact: Driver<Contact>
        //        let save: Driver<Void>
        //        let delete: Driver<Void>
        //        let editing: Driver<Bool>
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
        
        return Output(
                    editButtonTitle: editButtonTitle,
                    fetchedContact: fetchedContact,
//                      save: savePost,
//                      delete: deletePost,
//                      editing: editing,
                      contact: contact,
                      error: errorTracker.asDriver())
    }
}
