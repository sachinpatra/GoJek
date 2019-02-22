//
//  ContactsModel.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/22/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources


/*
enum ContactListSectionModel {
    case ContactListSection(header: String, items: [ContactListSectionItem])
}

enum ContactListSectionItem {
    case ContactRow(id: Int, contact: Contact)
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
        case .ContactRow(id: let indentity, contact: _):
            return indentity
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
*/
