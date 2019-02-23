//
//  ContactMapping.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation

extension Contact: Identifiable {}

extension Contact {
    func toJSON() -> [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phoneNumber": phoneNumber,
            "detailURL": detailURL,
            "favourite": favourite,
            "uid": uid
        ]
    }
}

extension Contact: Encodable {
    var encoder: NETPost {
        return NETPost(with: self)
    }
}

final class NETPost: NSObject, NSCoding, DomainConvertibleType {
    struct Keys {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let favourite = "favourite"
        static let uid = "uid"
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let detailURL = "detailURL"
    }
    let firstName: String
    let lastName: String
    let favourite: Bool
    let uid: Int
    let email: String
    let phoneNumber: String
    let detailURL: String
    
    init(with domain: Contact) {
        self.firstName = domain.firstName
        self.lastName = domain.lastName
        self.favourite = domain.favourite
        self.uid = domain.uid
        self.email = domain.email
        self.phoneNumber = domain.phoneNumber
        self.detailURL = domain.detailURL
    }
    
    init?(coder aDecoder: NSCoder) {
        guard
            let firstName = aDecoder.decodeObject(forKey: Keys.firstName) as? String,
            let lastName = aDecoder.decodeObject(forKey: Keys.lastName) as? String,
            let favourite = aDecoder.decodeObject(forKey: Keys.favourite) as? Bool,
            let uid = aDecoder.decodeObject(forKey: Keys.uid) as? Int,
            let email = aDecoder.decodeObject(forKey: Keys.email) as? String,
            let phoneNumber = aDecoder.decodeObject(forKey: Keys.phoneNumber) as? String,
            let detailURL = aDecoder.decodeObject(forKey: Keys.detailURL) as? String
            else {
                return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.favourite = favourite
        self.uid = uid
        self.email = email
        self.phoneNumber = phoneNumber
        self.detailURL = detailURL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: Keys.firstName)
        aCoder.encode(lastName, forKey: Keys.lastName)
        aCoder.encode(favourite, forKey: Keys.favourite)
        aCoder.encode(uid, forKey: Keys.uid)
        aCoder.encode(email, forKey: Keys.email)
        aCoder.encode(phoneNumber, forKey: Keys.phoneNumber)
        aCoder.encode(detailURL, forKey: Keys.detailURL)
    }
    
    func asDomain() -> Contact {
        return Contact(firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    detailURL: detailURL,
                    uid: uid,
                    favourite: favourite)
    }
}
