//
//  ContactUseCase.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxSwift

public protocol UseCaseProvider {
    func makeContactsUseCase() -> ContactUseCase
}

public protocol ContactUseCase {
    func contacts() -> Observable<[Contact]>
    func contact(contactId: Int) -> Observable<Contact>
    func save(contact: Contact) -> Observable<Void>
    func delete(contact: Contact) -> Observable<Void>
    func update(contact: Contact) -> Observable<Void>
}
