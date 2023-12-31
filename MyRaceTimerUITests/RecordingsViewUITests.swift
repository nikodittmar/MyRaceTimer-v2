//
//  RecordingsViewUITests.swift
//  MyRaceTimerUITests
//
//  Created by Niko Dittmar on 12/30/23.
//

import XCTest

final class RecordingsViewTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments += ["-testing"]
        app.launch()
        continueAfterFailure = false
    }

    func testChangeName() throws {
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        let collectionViewsQuery = app.collectionViews
        let recordingNameField = collectionViewsQuery.cells.textFields["Recording List Name"]
        recordingNameField.tap()
        recordingNameField.typeText("test")
        XCUIApplication().keyboards.buttons["return"].tap()
        app.navigationBars["Recording Lists"].otherElements["Close"].buttons["Close"].tap()
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        XCTAssertEqual(recordingNameField.value as! String, "test")
    }
    
    func testChangeType() throws {
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.segmentedControls.buttons["Finish"].tap()
        app.navigationBars["Recording Lists"].otherElements["Close"].buttons["Close"].tap()
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        XCTAssert(collectionViewsQuery.segmentedControls.buttons["Finish"].isSelected)
    }
    
    func testDisabledButtons() throws {
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        let collectionViewsQuery = app.collectionViews
        XCTAssertFalse(collectionViewsQuery.cells.buttons["Create New Recording List"].isEnabled)
        XCTAssertFalse(collectionViewsQuery.cells.buttons["Delete Recording List"].isEnabled)
        XCTAssertFalse(app.navigationBars["Recording Lists"].otherElements["Share"].buttons["Share"].isEnabled)
    }
    
    func testSwitchRecordingLists() throws {
        let recordingsButton = app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"]
        let collectionViewsQuery = app.collectionViews
        let recordingNameField = collectionViewsQuery.cells.textFields["Recording List Name"]
        
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Two"].tap()
        app.buttons["Three"].tap()
        
        recordingsButton.tap()
        
        recordingNameField.tap()
        recordingNameField.typeText("test1")
        XCUIApplication().keyboards.buttons["return"].tap()
        
        collectionViewsQuery.segmentedControls.buttons["Finish"].tap()
        
        collectionViewsQuery.cells.buttons["Create New Recording List"].tap()
        
        app.buttons["Record Time"].tap()
        app.buttons["Four"].tap()
        app.buttons["Five"].tap()
        app.buttons["Six"].tap()
        
        recordingsButton.tap()
        
        recordingNameField.tap()
        recordingNameField.typeText("test2")
        XCUIApplication().keyboards.buttons["return"].tap()
        
        collectionViewsQuery.cells.buttons["test1, 1 Recording, Finish"].tap()
        XCTAssert(app.collectionViews["Recordings"].cells.staticTexts["123"].exists)
        recordingsButton.tap()
        
        XCTAssertEqual(recordingNameField.value as! String, "test1")
        XCTAssert(collectionViewsQuery.segmentedControls.buttons["Finish"].isSelected)
        
        collectionViewsQuery.cells.buttons["test2, 1 Recording, Start"].tap()
        
        XCTAssert(app.collectionViews["Recordings"].cells.staticTexts["456"].exists)
        recordingsButton.tap()
        
        XCTAssertEqual(recordingNameField.value as! String, "test2")
        XCTAssert(collectionViewsQuery.segmentedControls.buttons["Start"].isSelected)
    }
    
    func testDeleteRecordingList() throws {
        let recordingsButton = app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"]
        let collectionViewsQuery = app.collectionViews
        let recordingNameField = collectionViewsQuery.cells.textFields["Recording List Name"]
        
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Two"].tap()
        app.buttons["Three"].tap()
        
        recordingsButton.tap()
        
        recordingNameField.tap()
        recordingNameField.typeText("test")
        XCUIApplication().keyboards.buttons["return"].tap()
        
        collectionViewsQuery.segmentedControls.buttons["Finish"].tap()
        
        collectionViewsQuery.buttons["Delete Recording List"].tap()
        
        app.alerts["Are you sure you want to delete this Recording Set?"].scrollViews.otherElements.buttons["Yes"].tap()
        
        XCTAssertEqual(app.collectionViews["Recordings"].cells.count, 0)
        
        recordingsButton.tap()
        
        XCTAssertEqual(recordingNameField.value as! String, "Recording List Name")
        XCTAssert(collectionViewsQuery.segmentedControls.buttons["Start"].isSelected)
    }
    
    func testCreateRecordingList() throws {
        let recordingsButton = app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"]
        let collectionViewsQuery = app.collectionViews
        let recordingNameField = collectionViewsQuery.cells.textFields["Recording List Name"]
        
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Two"].tap()
        app.buttons["Three"].tap()
        
        recordingsButton.tap()
        
        recordingNameField.tap()
        recordingNameField.typeText("test1")
        XCUIApplication().keyboards.buttons["return"].tap()
        
        collectionViewsQuery.segmentedControls.buttons["Finish"].tap()
        
        collectionViewsQuery.cells.buttons["Create New Recording List"].tap()
        
        XCTAssertEqual(app.collectionViews["Recordings"].cells.count, 0)
        
        recordingsButton.tap()
        
        XCTAssertEqual(recordingNameField.value as! String, "Recording List Name")
        XCTAssert(collectionViewsQuery.segmentedControls.buttons["Start"].isSelected)
    }
    
    func testMissingPlateWarning() throws {
        app.buttons["Record Time"].tap()
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        XCTAssert(app.collectionViews.cells.staticTexts["Missing Plate Numbers"].exists)
    }
    
    func testMissingTimestampWarning() throws {
        app.buttons["Add Plate Number"].tap()
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        XCTAssert(app.collectionViews.cells.staticTexts["Missing Timestamps"].exists)
    }
    
    func testDuplicatePlateWarning() throws {
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"].tap()
        XCTAssert(app.collectionViews.cells.staticTexts["Duplicate Plate Numbers"].exists)
    }
    
    func testWarningCountThree() throws {
        let recordingsButton = app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"]
        let collectionViewsQuery = app.collectionViews
        
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Add Plate Number"].tap()
        
        recordingsButton.tap()
        collectionViewsQuery.cells.buttons["Create New Recording List"].tap()
        recordingsButton.tap()
        
        XCTAssert(collectionViewsQuery.cells.staticTexts["3"].exists)
    }
    
    func testWarningCountTwo() throws {
        let recordingsButton = app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"]
        let collectionViewsQuery = app.collectionViews
        
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Record Time"].tap()
        
        recordingsButton.tap()
        collectionViewsQuery.cells.buttons["Create New Recording List"].tap()
        recordingsButton.tap()
        
        XCTAssert(collectionViewsQuery.cells.staticTexts["2"].exists)
    }
    
    func testWarningCountOne() throws {
        let recordingsButton = app.navigationBars["MyRaceTimer"].otherElements["Recordings"].buttons["Recordings"]
        let collectionViewsQuery = app.collectionViews
        
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        app.buttons["Record Time"].tap()
        app.buttons["One"].tap()
        
        recordingsButton.tap()
        collectionViewsQuery.cells.buttons["Create New Recording List"].tap()
        recordingsButton.tap()
        
        XCTAssert(collectionViewsQuery.cells.staticTexts["1"].exists)
    }
}
