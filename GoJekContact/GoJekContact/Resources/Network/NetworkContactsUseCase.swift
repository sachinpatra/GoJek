//
//  NetworkContactsUseCase.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkContactsUseCase<Cache>: ContactUseCase where Cache: AbstractCache, Cache.T == Contact {
    private let network: ContactsNetwork
    private let cache: Cache
    
    init(network: ContactsNetwork, cache: Cache) {
        self.network = network
        self.cache = cache
    }
    
    func contacts() -> Observable<[Contact]> {
        let fetchPosts = cache.fetchObjects().asObservable()
        let stored = network.fetchContacts()
            .flatMap {
                return self.cache.save(objects: $0)
                    .asObservable()
                    .map(to: [Contact].self)
                    .concat(Observable.just($0))
        }
        
        return fetchPosts.concat(stored)
    }
    
    func save(contact: Contact) -> Observable<Void> {
        return network.createContact(contact: contact)
            .map { _ in }
    }
    
    func delete(contact: Contact) -> Observable<Void> {
        return network.deleteContact(contactId: "\(contact.uid)").map({_ in})
    }
    
    func update(contact: Contact) -> Observable<Void> {
        return network.updateContact(contactId: "\(contact.uid)", params: [:]).map({_ in})
    }
}

struct MapFromNever: Error {}
extension ObservableType where E == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
