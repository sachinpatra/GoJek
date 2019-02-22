//
//  Contact.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation

public struct Contact: Codable {
    public let firstName: String
    public let lastName: String
    public let favourite: Bool
    public let uid: Int

    public init(firstName: String,
                lastName: String,
                uid: Int,
                favourite: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.favourite = favourite
        self.uid = uid
    }
    
    private enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case favourite
        case uid
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        favourite = try container.decode(Bool.self, forKey: .favourite)
        uid = try container.decode(Int.self, forKey: .favourite)
    }
}

extension Contact: Equatable {
    public static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.uid == rhs.uid &&
            lhs.favourite == rhs.favourite
    }
}
