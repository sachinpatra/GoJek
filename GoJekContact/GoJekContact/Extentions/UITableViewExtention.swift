//
//  UITableViewExtention.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String {get}
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
}

extension UITableView {
    
    public func beginRefreshing() {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else { return }
        
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
