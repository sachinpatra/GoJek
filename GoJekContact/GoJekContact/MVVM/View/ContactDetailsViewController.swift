//
//  ContactDetailsViewController.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/24/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import RxSwift

class ContactDetailsViewController: UIViewController {

    var viewModel: ContactDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem

    }


}
