//
//  ContactsListViewModelTests.swift
//  GoJekContactTests
//
//  Created by Sachin Kumar Patra on 2/27/19.
//  Copyright © 2019 Sachin Kumar Patra. All rights reserved.
//

import XCTest
@testable import GoJekContact
import RxSwift
import RxCocoa

enum TestError: Error {
    case test
}

class ContactsListViewModelTests: XCTestCase {

    var allContactsUseCase: AllContactsUseCaseMock!
    var contactsNavigator: ContactsNavigatorMock!
    var viewModel: ContactsListViewModel!
    let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        allContactsUseCase = AllContactsUseCaseMock()
        contactsNavigator = ContactsNavigatorMock()
        viewModel = ContactsListViewModel(useCase: allContactsUseCase, navigator: contactsNavigator)
    }

    override func tearDown() {
    }

    func testFetchAllContacts() {
        // arrange
        let trigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(fetchAllContactsAction: trigger))
        
        // act
        output.contacts.drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        // assert
        XCTAssert(allContactsUseCase.contacts_Called)
    }
    
    func testSelectContact() {
        // arrange
        let select = PublishSubject<IndexPath>()
        let output = viewModel.transform(input: createInput(selection: select))
        let contacts = createContacts()
        allContactsUseCase.fetchedContacts = Observable.just(contacts)

        // act
        output.contacts.drive().disposed(by: disposeBag)
        output.selectedContact.drive().disposed(by: disposeBag)
        select.onNext(IndexPath(row: 1, section: 0))
        
        // assert
        XCTAssertNotNil(output.selectedContact)
    }
    
    private func createInput(fetchAllContactsAction: Observable<Void> = Observable.concat(),
                             createContactAction: Observable<Void> = Observable.never(),
                             selection: Observable<IndexPath> = Observable.never())
        -> ContactsListViewModel.Input {
            return ContactsListViewModel.Input(
                fetchAllContactsAction: fetchAllContactsAction.asDriverOnErrorJustComplete(),
                createContactAction: createContactAction.asDriverOnErrorJustComplete(),
                selection: selection.asDriverOnErrorJustComplete())
    }
    
    private func createContacts() -> [Contact] {
        return [
            Contact(firstName: "first", lastName: "last", email: "email", phoneNumber: "phone", detailURL: "url", uid: 0, profilePic: "pic", favourite: true),
            Contact(firstName: "first", lastName: "last", email: "email", phoneNumber: "phone", detailURL: "url", uid: 1, profilePic: "pic", favourite: true)
        ]
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
