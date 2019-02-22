//
//  Utility.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class Utility {
    class func showAlert(withMessage message: String, title: String? = nil) {
        let alert = UIAlertController(style: .alert, title: title, message: message)
        alert.addAction(title: "OK")
        alert.show()
    }
    
    class func handleserviceError(response: DataResponse<Any>) -> [JSON]? {
        guard response.result.isSuccess else {
            Utility.showAlert(withMessage: (response.result.error?.localizedDescription)!)
            return nil
        }
        
        guard let responseDics = JSON(response.result.value!).array else { return nil }
        
        return responseDics
    }
}
