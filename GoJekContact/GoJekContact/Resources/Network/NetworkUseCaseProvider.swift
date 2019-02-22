//
//  NetworkUseCaseProvider.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation

public final class NetworkUseCaseProvider: UseCaseProvider {
    private let networkProvider: NetworkProvider
    
    public init() {
        networkProvider = NetworkProvider()
    }
    
    public func makeContactsUseCase() -> ContactUseCase {
        return NetworkContactsUseCase(network: networkProvider.makeContactsNetwork(),
                            cache: Cache<Contact>(path: "allPosts"))
    }
}
