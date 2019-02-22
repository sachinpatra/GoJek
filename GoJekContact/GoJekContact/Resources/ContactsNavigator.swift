//
//  ContactsNavigator.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit

protocol ContactsNavigator {
    func toCreateContact()
    func toContact(_ contact: Contact)
    func toContacts()
}

class DefaultContactsNavigator: ContactsNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(services: UseCaseProvider, navigationController: UINavigationController, storyBoard: UIStoryboard) {
        self.services = services
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toCreateContact() {
        
    }
    
    func toContact(_ contact: Contact) {
        
    }
    
    func toContacts() {
        let vc = storyBoard.instantiateViewController(ofType: ContactsListViewController.self)
        vc.viewModel = ContactsListViewModel(useCase: services.makeContactsUseCase(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
