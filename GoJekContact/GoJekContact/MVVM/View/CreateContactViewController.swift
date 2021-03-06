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
    
    var output: CreateContactViewModel.Output!
    
    lazy var picker: UIImagePickerController = {
        $0.delegate = self
        $0.sourceType = .camera
        $0.allowsEditing = false
        return $0
    }(UIImagePickerController())

    
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
        
        output = viewModel.transform(input: input)

        [output.dismiss.drive(),
         output.contact.drive(contactBinding),
         output.doneEnabled.drive(saveButton.rx.isEnabled),
         output.error.drive( Binder(self, binding: { (vc, error) in
            print("\(error.localizedDescription)")
         }))
        ].forEach({$0.disposed(by: disposeBag)})
        
        cameraButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.present(self.picker, animated: true)
        }).disposed(by: disposeBag)
    }
    
    var contactBinding: Binder<Contact?> {
        return Binder(self, binding: { (vc, contact) in
            if let con = contact {
                let imageURL = URL(string: Constants.BASE_URL+con.profilePic)
                vc.profileImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "placeholder"))
                vc.firstNameTextField.text = con.firstName
                vc.lastNameTextField.text = con.lastName
                vc.mobileTextField.text = con.phoneNumber
                vc.emailTextField.text = con.email
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 164.5
        } else {
            return 44
        }
    }
}

// MARK: - ImagePicker delegate
extension CreateContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        profileImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
