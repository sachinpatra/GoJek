//
//  CreateContactViewModel.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/25/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxCocoa

extension CreateContactViewModel {
    struct Input {
        let cancelAction: Driver<Void>
        let saveAction: Driver<Void>
        //        let title: Driver<String>
        //        let details: Driver<String>
    }
    
    struct Output {
            let dismiss: Driver<Void>
        //        let saveEnabled: Driver<Bool>
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

        let dismiss = input.cancelAction
            .do(onNext: navigator.dismiss)

        
        return Output(dismiss: dismiss
                      //saveEnabled: canSave
                    )
    }
}
