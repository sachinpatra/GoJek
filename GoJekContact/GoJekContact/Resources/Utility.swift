//
//  Utility.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation


protocol ReusableView: class {
    static var reuseIdentifier: String {get}
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
