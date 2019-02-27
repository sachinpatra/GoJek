//
//  ContactsNavigatorMock.swift
//  GoJekContactTests
//
//  Created by Sachin Kumar Patra on 2/27/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import XCTest
@testable import GoJekContact

class ContactsNavigatorMock: ContactsNavigator {
    func toCreateContact() {
        
    }
    
    var toContactCalled = false
    var selectedContact: Contact?

    func toContact(_ contact: Contact) {
        toContactCalled = true
        selectedContact = contact
    }
    
    func toContacts() {
        
    }
    
    func toEditContact(_ contact: Contact) {
        
    }
}
