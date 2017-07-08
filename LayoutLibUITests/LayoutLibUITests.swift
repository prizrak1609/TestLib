//
//  LayoutLibUITests.swift
//  LayoutLibUITests
//
//  Created by Dima Gubatenko on 08.07.17.
//
//

import XCTest

class LayoutLibUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssertTrue(true)
    }

    func testAddFirst() {
        let app = XCUIApplication()
        app.buttons["Add last"].tap()
        let addFirstButton = app.buttons["Add first"]
        for _ in 0...50 {
            addFirstButton.tap()
        }
    }

    func testAddLast() {
        let addLastButton = XCUIApplication().buttons["Add last"]
        for _ in 0...50 {
            addLastButton.tap()
        }
    }

    func testAddRandom() {
        let app = XCUIApplication()
        app.buttons["Add last"].tap()
        let addRandomButton = app.buttons["Add random"]
        for _ in 0...50 {
            addRandomButton.tap()
        }
    }

    func testRemoveFirst() {
        let app = XCUIApplication()
        app.buttons["Add last"].tap()
        let addFirstButton = app.buttons["Add first"]
        for _ in 0...50 {
            addFirstButton.tap()
        }
        let removeFirstButton = app.buttons["Remove first"]
        for _ in 0...50 {
            removeFirstButton.tap()
        }
    }

    func testRemoveLast() {
        let app = XCUIApplication()
        app.buttons["Add last"].tap()
        let addFirstButton = app.buttons["Add first"]
        for _ in 0...50 {
            addFirstButton.tap()
        }
        let removeLastButton = app.buttons["Remove last"]
        for _ in 0...50 {
            removeLastButton.tap()
        }
    }

    func testRemoveRandom() {
        let app = XCUIApplication()
        app.buttons["Add last"].tap()
        let addFirstButton = app.buttons["Add first"]
        for _ in 0...50 {
            addFirstButton.tap()
        }
        let removeRandomButton = app.buttons["Remove random"]
        for _ in 0...50 {
            removeRandomButton.tap()
        }
    }

    func testRemoveAll() {
        let app = XCUIApplication()
        app.buttons["Add last"].tap()
        let addFirstButton = app.buttons["Add first"]
        for _ in 0...50 {
            addFirstButton.tap()
        }
        app.buttons["Remove all"].tap()
    }
}
