//
//  UIStoryboardExtention.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit

extension UIViewController: ReusableView {
}

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseIdentifier) as? T else {
            fatalError()
        }
        return viewController
    }
}
