//
//  test2.swift
//  A1
//
//  Created by Li Wang on 9/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import XCTest

class test2: XCTestCase {
        
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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["ic room 48pt"].tap()
        app.buttons["ic movie white 36pt"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Deadpool"].tap()
        
        let backButton = app.navigationBars["A1.MovieUIView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0)
        backButton.tap()
        app.buttons["ic account box white 36pt"].tap()
        app.buttons["ic settings white 36pt"].tap()
        app.navigationBars["A1.SettingView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        app.navigationBars["A1.LoginView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        tablesQuery.staticTexts["Batman v Superman: Dawn of Justice"].tap()
        backButton.tap()
        
        let a1MovietableviewNavigationBar = app.navigationBars["A1.MovieTableView"]
        a1MovietableviewNavigationBar.childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        app.navigationBars["A1.CinemaTableView"].buttons["Silverado Cinema"].tap()
        app.buttons["ic movie 48pt"].tap()
        a1MovietableviewNavigationBar.buttons["Silverado Cinema"].tap()
        
    }
    
}
