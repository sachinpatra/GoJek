//
//  StringExtention.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/24/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        //request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("", forHTTPHeaderField: "description")
        
        return request
    }
}
