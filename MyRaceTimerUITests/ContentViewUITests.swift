//
//  ContentViewUITests.swift
//  MyRaceTimerUITests
//
//  Created by Niko Dittmar on 12/27/23.
//

import XCTest

final class ContentViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments += ["-testing"]
        app.launch()
        continueAfterFailure = false
    }
    
    func testCreateRecording() throws {
        let recordingsList = app.collectionViews["Recordings"]
        XCTAssertEqual(recordingsList.cells.count, 0)
        app.buttons["Record Time"].tap()
        XCTAssertEqual(recordingsList.cells.count, 1)
    }
    
    func testAddPlate() throws {
        let recordingsList = app.collectionViews["Recordings"]
        XCTAssertEqual(recordingsList.cells.count, 0)
        app.buttons["Add Plate Number"].tap()
        XCTAssertEqual(recordingsList.cells.count, 1)
    }
    
    func testAddPlateRecordTime() throws {
        let recordingsList = app.collectionViews["Recordings"]
        app.buttons["Add Plate Number"].tap()
        XCTAssert(recordingsList.cells.firstMatch.staticTexts["--:--:--.--"].exists)
        app.buttons["Record Time"].tap()
        XCTAssertFalse(recordingsList.cells.firstMatch.staticTexts["--:--:--.--"].exists)
        XCTAssertEqual(recordingsList.cells.count, 1)
    }
    
    func testNumberPad() throws {
        let recordingsList = app.collectionViews["Recordings"]
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        XCTAssert(recordingsList.cells.staticTexts["1"].exists)
        app.buttons["Two"].tap()
        XCTAssert(recordingsList.cells.staticTexts["12"].exists)
        app.buttons["Three"].tap()
        XCTAssert(recordingsList.cells.staticTexts["123"].exists)
        app.buttons["Backspace"].tap()
        XCTAssert(recordingsList.cells.staticTexts["12"].exists)
    }
    
    func testDeleteRecording() throws {
        let recordingsList = app.collectionViews["Recordings"]
        app.buttons["Record Time"].tap()
        XCTAssertEqual(recordingsList.cells.count, 1)
        app.buttons["Trash"].tap()
        app.alerts["Are you sure you want to delete this recording?"].scrollViews.otherElements.buttons["Yes"].tap()
        let doesNotExistPredicate = NSPredicate(format: "exists == FALSE")
        expectation(for: doesNotExistPredicate, evaluatedWith: recordingsList.cells.firstMatch, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testRecordingsCount() throws {
        XCTAssert(app.staticTexts["0 Recordings"].exists)
        app.buttons["Record Time"].tap()
        XCTAssert(app.staticTexts["1 Recording"].exists)
        app.buttons["Record Time"].tap()
        XCTAssert(app.staticTexts["2 Recordings"].exists)
    }
}
