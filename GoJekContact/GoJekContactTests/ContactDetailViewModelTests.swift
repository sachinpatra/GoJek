//
//  ContactDetailViewModelTests.swift
//  GoJekContactTests
//
//  Created by Sachin Kumar Patra on 2/27/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import XCTest
@testable import GoJekContact
import RxSwift
import RxCocoa

class ContactDetailViewModelTests: XCTestCase {

    var allContactsUseCase: AllContactsUseCaseMock!
    var contactsNavigator: ContactsNavigatorMock!
    var viewModel: ContactDetailViewModel!
    let disposeBag = DisposeBag()

    override func setUp() {
        allContactsUseCase = AllContactsUseCaseMock()
        contactsNavigator = ContactsNavigatorMock()
        viewModel = ContactDetailViewModel(contact: createContact(), useCase: allContactsUseCase, navigator: contactsNavigator)

    }

    override func tearDown() {
    }

    func testDeleteContact() {
        // arrange
        let trigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(editAction: trigger))
        
        // act
        output.deleteContact.drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        // assert
        XCTAssertNotNil(output.deleteContact)
    }

    private func createInput(editAction: Observable<Void> = Observable.never(),
                             fetchContactAction: Observable<Void> = Observable.never(),
                             favouriteAction: Observable<Void> = Observable.never(),
                             messageAction: Observable<Void> = Observable.never(),
                             callAction: Observable<Void> = Observable.never(),
                             emailAction: Observable<Void> = Observable.never())
        -> ContactDetailViewModel.Input {
            return ContactDetailViewModel.Input(
                editAction: editAction.asDriverOnErrorJustComplete(),
                fetchContactAction: fetchContactAction.asDriverOnErrorJustComplete(),
                favouriteAction: favouriteAction.asDriverOnErrorJustComplete(),
                messageAction: messageAction.asDriverOnErrorJustComplete(),
                callAction: callAction.asDriverOnErrorJustComplete(),
                emailAction: emailAction.asDriverOnErrorJustComplete())
    }
    
    private func createContact() -> Contact {
        return
            Contact(firstName: "first", lastName: "last", email: "email", phoneNumber: "phone", detailURL: "url", uid: 4017, profilePic: "pic", favourite: true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
