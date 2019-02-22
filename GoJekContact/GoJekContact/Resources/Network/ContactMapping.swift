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
    }
    let firstName: String
    let lastName: String
    let favourite: Bool
    let uid: Int
    
    init(with domain: Contact) {
        self.firstName = domain.firstName
        self.lastName = domain.lastName
        self.favourite = domain.favourite
        self.uid = domain.uid
    }
    
    init?(coder aDecoder: NSCoder) {
        guard
            let firstName = aDecoder.decodeObject(forKey: Keys.firstName) as? String,
            let lastName = aDecoder.decodeObject(forKey: Keys.lastName) as? String,
            let favourite = aDecoder.decodeObject(forKey: Keys.favourite) as? Bool,
            let uid = aDecoder.decodeObject(forKey: Keys.uid) as? Int
            else {
                return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.favourite = favourite
        self.uid = uid
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: Keys.firstName)
        aCoder.encode(lastName, forKey: Keys.lastName)
        aCoder.encode(favourite, forKey: Keys.favourite)
        aCoder.encode(uid, forKey: Keys.uid)
    }
    
    func asDomain() -> Contact {
        return Contact(firstName: firstName,
                    lastName: lastName,
                    uid: uid,
                    favourite: favourite)
    }
}
