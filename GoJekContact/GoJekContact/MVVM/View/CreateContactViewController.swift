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

class CreateContactViewController: UITableViewController {

    private let disposeBag = DisposeBag()
    var viewModel: CreateContactViewModel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)

        
        bindViewModel()

    }

    private func bindViewModel() {
        
        let input = CreateContactViewModel.Input(cancelAction: cancelButton.rx.tap.asDriver(),
                                                 saveAction: saveButton.rx.tap.asDriver(),
                                                 firstName: firstNameTextField.rx.text.orEmpty.asDriver(),
                                                 lastName: lastNameTextField.rx.text.orEmpty.asDriver(),
                                                 mobile: mobileTextField.rx.text.orEmpty.asDriver(),
                                                 email: emailTextField.rx.text.orEmpty.asDriver()
        )
        
        let output = viewModel.transform(input: input)

        [output.dismiss.drive(),
         output.doneEnabled.drive(saveButton.rx.isEnabled)
            ].forEach({$0.disposed(by: disposeBag)})
    }
}
