//
//  GoJekContactUITests.swift
//  GoJekContactUITests
//
//  Created by Sachin Kumar Patra on 2/21/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func waitForActivityIndicatorToFinishSpinning(_ activityIndicatorElement: XCUIElement, timeout: TimeInterval = 30.0) {
        //        let inProgressPredicate = NSPredicate(format: "exists == true")
        //        self.expectation(for: inProgressPredicate, evaluatedWith: activityIndicatorElement, handler: nil)
        //        self.waitForExpectations(timeout: timeout, handler: nil)
        
        let progressHaltedPredicate = NSPredicate(format: "exists == false")
        self.expectation(for: progressHaltedPredicate, evaluatedWith: activityIndicatorElement, handler: nil)
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
}

class GoJekContactUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        self.app.launch()
    }

    override func tearDown() {
    }

    func testLoadAllContacts() {
        self.waitForActivityIndicatorToFinishSpinning(self.app.activityIndicators.firstMatch, timeout: 70.0)
    }
    
    func testCreateContact() {
        self.waitForActivityIndicatorToFinishSpinning(self.app.activityIndicators.firstMatch, timeout: 70.0)
        app.navigationBars["Contact"].buttons["Add"].tap()
        app.tables.cells.containing(.staticText, identifier: "First Name").children(matching: .textField).element.tap()
        app.tables.cells.containing(.staticText, identifier: "First Name").children(matching: .textField).element.typeText("My First Name")
        app.tables.cells.containing(.staticText, identifier: "Last Name").children(matching: .textField).element.tap()
        app.tables.cells.containing(.staticText, identifier: "Last Name").children(matching: .textField).element.typeText("My Last Name")
        app.tables.cells.containing(.staticText, identifier: "mobile").children(matching: .textField).element.tap()
        app.tables.cells.containing(.staticText, identifier: "mobile").children(matching: .textField).element.typeText("9742783146")
        app.tables.cells.containing(.staticText, identifier: "email").children(matching: .textField).element.tap()
        app.tables.cells.containing(.staticText, identifier: "email").children(matching: .textField).element.typeText("uitest@gojek.com")
        app.navigationBars["GoJekContact.CreateContactView"].buttons["Done"].tap()

    }
    
    func testDeleteContact() {
        self.waitForActivityIndicatorToFinishSpinning(self.app.activityIndicators.firstMatch, timeout: 70.0)
        app.tables.cells.firstMatch.tap()
        self.waitForActivityIndicatorToFinishSpinning(self.app.activityIndicators.firstMatch, timeout: 30.0)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Delete"]/*[[".cells.staticTexts[\"Delete\"]",".staticTexts[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["GoJek"].buttons["OK"].tap()
    }
    
    func testDetailContactAllOperions() {
        self.waitForActivityIndicatorToFinishSpinning(self.app.activityIndicators.firstMatch, timeout: 70.0)
        app.tables.cells.firstMatch.tap()
        self.waitForActivityIndicatorToFinishSpinning(self.app.activityIndicators.firstMatch, timeout: 30.0)
        
        app.navigationBars["GoJekContact.ContactDetailsView"].buttons["Edit"].tap()
        app.navigationBars["GoJekContact.CreateContactView"].buttons["Cancel"].tap()

    }

}
