//
//  CreateContactViewModel.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/25/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension CreateContactViewModel {
    struct Input {
        let cancelAction: Driver<Void>
        let saveAction: Driver<Void>
        let firstName: Driver<String>
        let lastName: Driver<String>
        let mobile: Driver<String>
        let email: Driver<String>
    }
    
    struct Output {
            let dismiss: Driver<Void>
            let doneEnabled: Driver<Bool>
    }
}

final class CreateContactViewModel: ViewModelType {
    private let useCase: ContactUseCase
    private let navigator: DefaultCreateContactNavigator

    init(useCase: ContactUseCase, navigator: DefaultCreateContactNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let allTextFields = Driver.combineLatest(input.firstName, input.lastName, input.mobile, input.email)
//        { (first, last, mobile, email) in
//            return !first.isEmpty && !last.isEmpty && !mobile.isEmpty && !email.isEmpty
//        }.startWith(false)
        
        let canSave = Driver.combineLatest(allTextFields, activityIndicator.asDriver()) {
            return !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty  && !$1
        }.startWith(false)

        let save = input.saveAction.withLatestFrom(allTextFields)
            .map { (first, last, mobile, email) in
                return Contact(firstName: first, lastName: last, email: email, phoneNumber: mobile, detailURL: "", uid: 0, profilePic: "", favourite: false)
                }.flatMapLatest { [unowned self] in
                    return self.useCase.save(contact: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorJustComplete()

        }

        let dismiss = Driver.of(save, input.cancelAction)
            .merge()
            .do(onNext: navigator.dismiss)

        
        return Output(dismiss: dismiss,
                      doneEnabled: canSave
                    )
    }
}
