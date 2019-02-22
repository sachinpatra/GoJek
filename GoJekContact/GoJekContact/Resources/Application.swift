//
//  Application.swift
//  GoJekContact
//
//  Created by Sachin Kumar Patra on 2/23/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import UIKit

final class Application {
    static let shared = Application()
    private let networkUseCaseProvider: UseCaseProvider!

    private init() {
        self.networkUseCaseProvider = NetworkUseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Contact", bundle: nil)
        let navController = UINavigationController()
        navController.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1)
        
        let networkNavigator = DefaultContactsNavigator(services: networkUseCaseProvider,
                                                     navigationController: navController,
                                                     storyBoard: storyboard)
        window.rootViewController = navController
        networkNavigator.toContacts()
    }
}
