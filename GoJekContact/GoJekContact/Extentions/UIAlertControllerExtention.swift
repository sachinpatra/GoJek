//
//  UIAlertControllerExtention.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(style: UIAlertController.Style, source: UIView? = nil, title: String? = nil, message: String? = nil, tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: style)
        
        if style == .actionSheet, let source = source {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        }
        
        if let color = tintColor {
            self.view.tintColor = color
        }
    }
    
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        }
    }
    
    @discardableResult
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        
        // button image
        if let image = image {
            action.setValue(image, forKey: "image")
        }
        
        // button title color
        if let color = color {
            action.setValue(color, forKey: "titleTextColor")
        }
        
        addAction(action)
        
        return action
    }
}
