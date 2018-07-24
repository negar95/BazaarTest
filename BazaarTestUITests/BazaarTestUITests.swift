//
//  BazaarTestUITests.swift
//  BazaarTestUITests
//
//  Created by negar on 97/Tir/27 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import XCTest

class BazaarTestUITests: XCTestCase {
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsRecentliesAppear() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let enterAMovieNameTextField = app.textFields["Enter a movie name"]
        enterAMovieNameTextField.tap()
        
        let table = app.otherElements.containing(.textField, identifier:"Enter a movie name").children(matching: .table).element
        XCTAssertTrue(table.exists)
    }

    func testIsEmptyTextFieldShowsToastMessage() {
        let searchButton = app.buttons["search"]
        searchButton.tap()
        XCTAssertTrue(app.staticTexts["I can't search for nothing!"].exists)
    }
}
