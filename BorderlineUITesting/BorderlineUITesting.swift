//
//  BorderlineUITesting.swift
//  BorderlineUITesting
//
//  Created by Jamie Dassoulas on 2017-12-20.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import XCTest

class BorderlineUITesting: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let app = XCUIApplication()
//        let element = app.collectionViews.children(matching: .cell).element(boundBy: 4).children(matching: .other).element
        snapshot("FirstScreen")
        app.buttons["Challenge"].tap()
        snapshot("Levels")
        app.buttons["Level 1"].tap()
        snapshot("Level1")
        let element = app.collectionViews.children(matching: .cell).element(boundBy: 4).children(matching: .other).element
        element.tap() // segue to Italy
        snapshot("Italy")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 13).children(matching: .other).element.tap() // segue to Canada
        snapshot("Canada")
        
//        app.textFields.containing(.button, identifier:"Clear text").element.typeText("ITALY")
//        app.textFields["Country Guess"].tap()
//        app.textFields["Country Guess"].typeText("ITALY")
//        app.textFields["Country Guess"].typeText("\r")
//        app.typeText("\r")
//        snapshot("success")
//        app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap() // segue to Level 1
        app.navigationBars.buttons.element(boundBy: 0).tap() // segue to Challenge
        app.navigationBars.buttons.element(boundBy: 0).tap() // segue to Main Screen
        app.buttons["Extras"].tap()
        snapshot("ExtraLevels")
        app.buttons["US States"].tap()
        app.buttons["Level 1"].tap()
        snapshot("USStates1")

//        app.navigationBars["Borderline"].buttons["Level 1"].tap()
//        app.navigationBars["Level 1"].buttons["Challenge"].tap()
//        app.navigationBars["Challenge"].buttons["Borderline"].tap()
//        app.buttons["Extra Levels"].tap()
//        app.navigationBars["Extra Levels"].buttons["Borderline"].tap()
//        app.buttons["Settings"].tap()
        
    }
    
}
