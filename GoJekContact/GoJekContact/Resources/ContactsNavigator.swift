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
    func toEditContact(_ contact: Contact)
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
        let navigator = DefaultCreateContactNavigator(navigationController: navigationController)
        let viewModel = CreateContactViewModel(useCase: services.makeContactsUseCase(), navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: CreateContactViewController.self)
        vc.viewModel = viewModel
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1)
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    func toEditContact(_ contact: Contact) {
        let navigator = DefaultCreateContactNavigator(navigationController: navigationController)
        let viewModel = CreateContactViewModel(useCase: services.makeContactsUseCase(), navigator: navigator, contact: contact)
        let vc = storyBoard.instantiateViewController(ofType: CreateContactViewController.self)
        vc.viewModel = viewModel
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1)
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    func toContact(_ contact: Contact) {
        let viewModel = ContactDetailViewModel(contact: contact, useCase: services.makeContactsUseCase(), navigator: self)
        let vc = storyBoard.instantiateViewController(ofType: ContactDetailsViewController.self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toContacts() {
        let vc = storyBoard.instantiateViewController(ofType: ContactsListViewController.self)
        vc.viewModel = ContactsListViewModel(useCase: services.makeContactsUseCase(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}

protocol CreateContactNavigator {
    func dismiss()
}

final class DefaultCreateContactNavigator: CreateContactNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
