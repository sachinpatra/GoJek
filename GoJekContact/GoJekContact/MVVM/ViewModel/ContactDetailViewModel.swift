//
//  ContactDetailViewModel.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/24/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import RxCocoa

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
        let errorTracker = ErrorTracker()

        return Output(
//                    editButtonTitle: editButtonTitle,
//                      save: savePost,
//                      delete: deletePost,
//                      editing: editing,
//                      post: post,
                      error: errorTracker.asDriver())
    }
}

extension ContactDetailViewModel {
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }
    
    struct Output {
//        let editButtonTitle: Driver<String>
//        let save: Driver<Void>
//        let delete: Driver<Void>
//        let editing: Driver<Bool>
//        let contact: Driver<Contact>
        let error: Driver<Error>
    }
}
