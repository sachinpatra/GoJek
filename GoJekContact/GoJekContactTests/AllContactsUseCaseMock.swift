//
//  AllContactsUseCaseMock.swift
//  GoJekContactTests
//
//  Created by Sachin Kumar Patra on 2/27/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import XCTest
@testable import GoJekContact
import RxSwift

class AllContactsUseCaseMock: ContactUseCase {
    var fetchedContacts: Observable<[Contact]> = Observable.just([])
    var contacts_Called = false

    func contacts() -> Observable<[Contact]> {
        contacts_Called = true
        return fetchedContacts
    }
    
    func contact(contactId: Int) -> Observable<Contact> {
        return fetchedContacts.map { ($0.filter {$0.uid == contactId}.first)!}
    }
    
    func save(contact: Contact) -> Observable<Void> {
        return fetchedContacts.mapToVoid()

    }
    
    func delete(contact: Contact) -> Observable<Void> {
        return fetchedContacts.mapToVoid()
    }
    
    func update(contact: Contact) -> Observable<Void> {
        return fetchedContacts.mapToVoid()
    }
    
}
