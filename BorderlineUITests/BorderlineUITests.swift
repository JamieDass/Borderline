//
//  BorderlineUITests.swift
//  BorderlineUITests
//
//  Created by James Dassoulas on 2016-08-20.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import XCTest

class BorderlineUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        sleep(1)
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
            }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.buttons["Challenge"].tap()
        sleep(3)
        let l1button = app.buttons["Level 1"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: l1button, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        app.buttons["Level 1"].tap()
        sleep(5)
        
//        app.collectionViews.children(matching: .cell).element(boundBy: 12).children(matching: .other).element.tap()
//        
//        let clearTextTextField = app.textFields.containing(.button, identifier:"Clear text").element
//        clearTextTextField.typeText("AUSTRALIA")
//        app.buttons["Done"].tap()
//        app.typeText("\n")
//        app.buttons["Next"].tap()
//        app.navigationBars["Borderline"].buttons["Level 1"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
