//
//  ContactsNetwork.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import RxSwift

public final class ContactsNetwork {
    private let network: Network<Contact>
    
    init(network: Network<Contact>) {
        self.network = network
    }
    
    public func fetchContacts() -> Observable<[Contact]> {
        return network.getItems("contacts.json")
    }
    
    public func fetchContact(contactId: String) -> Observable<Contact> {
        return network.getItem("posts", itemId: contactId)
    }
    
    public func createContact(contact: Contact) -> Observable<Contact> {
        return network.postItem("posts", parameters: contact.toJSON())
    }
    
    public func deleteContact(contactId: String) -> Observable<Contact> {
        return network.deleteItem("posts", itemId: contactId)
    }
    
    public func updateContact(contactId: String, params: [String: Any]) -> Observable<Contact> {
        return network.updateItem("posts", itemId: contactId, parameters: params)
    }
}