//
//  weathercast_demoUITests.swift
//  weathercast-demoUITests
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import XCTest

class weathercast_demoUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFlow() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let app = XCUIApplication()

        app.collectionViews.cells.element(boundBy: 0).tap()

        let expectation0 = expectation(for: NSPredicate(format: "exists = true"), evaluatedWith: app.buttons["close"], handler: nil)
        XCTWaiter().wait(for: [expectation0], timeout: 5.0)

        app.buttons["close"].tap()

        let expectation1 = expectation(for: NSPredicate(format: "exists = true"), evaluatedWith: app.collectionViews.cells.staticTexts["Paris"], handler: nil)
        XCTWaiter().wait(for: [expectation1], timeout: 5.0)

        XCTAssert(app.collectionViews.cells.staticTexts["Paris"].exists)

        app.collectionViews.cells.element(boundBy: 0).swipeUp()

        let expectation2 = expectation(for: NSPredicate(format: "exists = true"), evaluatedWith: app.collectionViews.cells.staticTexts["London"], handler: nil)
        XCTWaiter().wait(for: [expectation2], timeout: 5.0)

        XCTAssert(app.collectionViews.cells.staticTexts["London"].exists)

        app.collectionViews.cells.element(boundBy: 0).swipeUp()

        let expectation3 = expectation(for: NSPredicate(format: "exists = true"), evaluatedWith: app.collectionViews.cells.staticTexts["Tokyo"], handler: nil)
        XCTWaiter().wait(for: [expectation3], timeout: 5.0)

        XCTAssert(app.collectionViews.cells.staticTexts["Tokyo"].exists)
    }

}
