//
//  Contact.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxDataSources

public struct Contact: Codable {
    public let firstName: String
    public let lastName: String
    public let email: String
    public let phoneNumber: String
    public let detailURL: String
    public let favourite: Bool
    public let uid: Int
    public let profilePic: String

    public init(firstName: String,
                lastName: String,
                email: String,
                phoneNumber: String,
                detailURL: String,
                uid: Int,
                profilePic: String,
                favourite: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.detailURL = detailURL
        self.favourite = favourite
        self.uid = uid
        self.profilePic = profilePic
    }
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phoneNumber = "phone_number"
        case detailURL = "url"
        case favourite = "favorite"
        case uid = "id"
        case profilePic = "profile_pic"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let uid = try container.decodeIfPresent(Int.self, forKey: Contact.CodingKeys(rawValue: CodingKeys.uid.rawValue)!) {
            self.uid = uid
        } else {
            uid = try container.decodeIfPresent(Int.self, forKey: .uid) ?? 0
        }
        
        
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        favourite = try container.decode(Bool.self, forKey: .favourite)
        profilePic = try container.decode(String.self, forKey: .profilePic)
        
        if let detailURL = try container.decodeIfPresent(String.self, forKey: Contact.CodingKeys(rawValue: CodingKeys.detailURL.rawValue)!) {
            self.detailURL = detailURL
        } else {
            detailURL = try container.decodeIfPresent(String.self, forKey: .detailURL) ?? ""
        }
        
        if let email = try container.decodeIfPresent(String.self, forKey: Contact.CodingKeys(rawValue: CodingKeys.email.rawValue)!) {
            self.email = email
        } else {
            email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        }
        
        if let phoneNumber = try container.decodeIfPresent(String.self, forKey: Contact.CodingKeys(rawValue: CodingKeys.phoneNumber.rawValue)!) {
            self.phoneNumber = phoneNumber
        } else {
            phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        }
    }
}

extension Contact: Equatable {
    public static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.detailURL == rhs.detailURL &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.uid == rhs.uid &&
            lhs.profilePic == rhs.profilePic &&
            lhs.favourite == rhs.favourite
    }
}

enum ContactListSectionModel {
    case ContactListSection(header: String, items: [ContactListSectionItem])
}

enum ContactListSectionItem {
    case ContactRow(contact: Contact)
}

extension ContactListSectionModel: AnimatableSectionModelType {
    typealias Item = ContactListSectionItem
    
    var items: [Item] {
        switch  self {
        case .ContactListSection(header: _, items: let items):
            return items.map {$0}
        }
    }
    
    init(original: ContactListSectionModel, items: [Item]) {
        switch original {
        case let .ContactListSection(header: title, items: _):
            self = .ContactListSection(header: title, items: items)
        }
    }
}

extension ContactListSectionItem: IdentifiableType, Equatable {
    static func == (lhs: ContactListSectionItem, rhs: ContactListSectionItem) -> Bool {
        return true
    }
    
    typealias Identity = Int
    var identity: Int {
        switch self {
        case .ContactRow(contact: let contct):
            return contct.uid
        }
    }
}

extension ContactListSectionModel: IdentifiableType, Equatable {
    static func == (lhs: ContactListSectionModel, rhs: ContactListSectionModel) -> Bool {
        return true
    }
    
    typealias Identity = String
    var identity: String {
        switch self {
        case .ContactListSection(header: let title, items: _):
            return title
        }
    }
}

struct ContactDetailSection {
    var header: String
    var items: [Item]
}

struct ContactDetailRow {
    var title: String
    var detail: String
}

extension ContactDetailSection: AnimatableSectionModelType {
    typealias Item = ContactDetailRow
    
    var identity: String {
        return header
    }
    
    init(original: ContactDetailSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension ContactDetailRow: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    static func == (lhs: ContactDetailRow, rhs: ContactDetailRow) -> Bool {
        return true
    }
    
    var identity: String {
        return self.title
    }
}
