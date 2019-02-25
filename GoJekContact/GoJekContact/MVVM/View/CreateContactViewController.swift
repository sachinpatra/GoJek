//
//  CreateContactViewController.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/25/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateContactViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: CreateContactViewModel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()

    }

    private func bindViewModel() {
        
        let input = CreateContactViewModel.Input(cancelAction: cancelButton.rx.tap.asDriver(),
                                                 saveAction: saveButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)

        [output.dismiss.drive()
            ].forEach({$0.disposed(by: disposeBag)})
    }
}
