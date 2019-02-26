//
//  Network.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import SwiftyJSON

final class NetworkProvider {
    private let apiEndpoint: String
    
    public init() {
        apiEndpoint = "https://gojek-contacts-app.herokuapp.com"
    }
    
    public func makeContactsNetwork() -> ContactsNetwork {
        let network = Network<Contact>(apiEndpoint)
        return ContactsNetwork(network: network)
    }
}

final class Network<T: Decodable> {
    
    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }
    
    func getItems(_ path: String) -> Observable<[T]> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .data(.get, absolutePath)
            .debug()
            .observeOn(scheduler)
            .map({ data -> [T] in
                return try JSONDecoder().decode([T].self, from: data)
            })
    }
    
    func getItem(_ path: String, itemId: String) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId).json"
        return RxAlamofire
            .data(.get, absolutePath)
            .debug()
            .observeOn(scheduler)
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
    
    func postItem(_ path: String, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        let params = JSON(parameters)
        let payload = params.rawString()!
        return RxAlamofire
//            .request(.post, absolutePath, parameters: parameters)
            .request(.post, absolutePath, encoding: payload)
            .debug()
            .observeOn(scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
    
    func updateItem(_ path: String, itemId: String, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId).json"
        let params = JSON(parameters)
        let payload = params.rawString()!
        return RxAlamofire
//            .request(.put, absolutePath, parameters: parameters)
            .request(.post, absolutePath, encoding: payload)
            .debug()
            .observeOn(scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
    
    func deleteItem(_ path: String, itemId: String) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId).json"
        return RxAlamofire
            .request(.delete, absolutePath)
            .debug()
            .observeOn(scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
}
