//
//  ContentViewModelTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/25/23.
//

import XCTest
@testable import MyRaceTimer

@MainActor final class ContentViewModelTests: XCTestCase {
    var viewModel: ContentViewModel!
    var recordingList: RecordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
    
    override func setUp() {
        viewModel = ContentViewModel(forTesting: true)
        
        do {
            try viewModel.persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        do {
            try viewModel.persistenceController.loadRecordingList(id: recordingList.id)
        } catch {
            XCTFail("loadRecordingList() threw an error unexpectedly.")
        }
    }
    
    func testUpdateRecordings() throws {
        let expected = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000))]
        
        XCTAssert(viewModel.recordings.isEmpty)
        
        do {
            try viewModel.persistenceController.saveRecording(recording: expected[0], listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        viewModel.updateRecordings()
        
        XCTAssertEqual(viewModel.recordings, expected)
    }
    
    func testHandleRecordTime() throws {
        XCTAssert(viewModel.recordings.isEmpty)
        viewModel.handleRecordTime()
        XCTAssertEqual(viewModel.recordings.count, 1)
        if let recording = viewModel.recordings.first {
            XCTAssertEqual(recording.plate, "")
            XCTAssert(recording == viewModel.selectedRecording)
            XCTAssertFalse(viewModel.upcomingPlateSelected)
        } else {
            XCTFail("Expected one but no recordings were found.")
        }
        
    }
    
    func testHandleAddPlate() throws {
        XCTAssert(viewModel.recordings.isEmpty)
        viewModel.handleAddPlate()
        XCTAssertEqual(viewModel.recordings.count, 1)
        if let recording = viewModel.recordings.first {
            XCTAssertEqual(recording.timestamp, Date(timeIntervalSince1970: 0.0))
        } else {
            XCTFail("Expected one but no recordings were found.")
        }
    }
    
    func testHandleSelectRecording() throws {
        let recordings = [
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "321", timestamp: Date(timeIntervalSince1970: 1700000000)),
        ]
        
        do {
            try viewModel.persistenceController.saveRecording(recording: recordings[0], listId: recordingList.id)
            try viewModel.persistenceController.saveRecording(recording: recordings[1], listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.updateRecordings()
        
        XCTAssertEqual(viewModel.recordings.count, 2)
        
        XCTAssertNil(viewModel.selectedRecording)
        
        viewModel.handleSelectRecording(recordings[0])
        
        if let selectedRecording1 = viewModel.selectedRecording {
            XCTAssertEqual(selectedRecording1.id, recordings[0].id)
        } else {
            XCTFail("Expected selected recording to not be nil.")
        }
        
        viewModel.handleSelectRecording(recordings[1])
        
        if let selectedRecording2 = viewModel.selectedRecording {
            XCTAssertEqual(selectedRecording2.id, recordings[1].id)
        } else {
            XCTFail("Expected selected recording to not be nil.")
        }
        
        viewModel.handleSelectUpcomingPlate()
        
        XCTAssertNil(viewModel.selectedRecording)
        XCTAssertTrue(viewModel.upcomingPlateSelected)
        
        viewModel.handleSelectRecording(recordings[0])
        
        if let selectedRecording1 = viewModel.selectedRecording {
            XCTAssertEqual(selectedRecording1.id, recordings[0].id)
            XCTAssertFalse(viewModel.upcomingPlateSelected)
        } else {
            XCTFail("Expected selected recording to not be nil.")
        }
        
        viewModel.handleSelectRecording(recordings[0])
        
        XCTAssertNil(viewModel.selectedRecording)
        XCTAssertFalse(viewModel.upcomingPlateSelected)
    }
    
    func testHandleAppendPlateDigit() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000))

        do {
            try viewModel.persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.updateRecordings()
        
        viewModel.handleSelectRecording(recording)
        
        viewModel.handleAppendPlateDigit(4)
        
        XCTAssertEqual(viewModel.recordings.count, 1)
        
        if let recording = viewModel.recordings.first {
            XCTAssertEqual(recording.plate, "1234")
        }
    }
    
    func testHandleRemoveLastPlateDigit() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000))

        do {
            try viewModel.persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.updateRecordings()
        
        viewModel.handleSelectRecording(recording)
        
        viewModel.handleRemoveLastPlateDigit()
        
        XCTAssertEqual(viewModel.recordings.count, 1)
        
        if let recording = viewModel.recordings.first {
            XCTAssertEqual(recording.plate, "12")
        }
    }
    
    func testHandleDeleteRecording() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000))

        do {
            try viewModel.persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.updateRecordings()
        
        XCTAssertEqual(viewModel.recordings.count, 1)
        
        viewModel.handleSelectRecording(recording)
        
        viewModel.handleDeleteRecording()
        
        XCTAssertEqual(viewModel.recordings.count, 0)
    }

}
