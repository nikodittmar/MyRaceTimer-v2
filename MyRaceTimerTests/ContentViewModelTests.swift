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
        let expected = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        
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
        } else {
            XCTFail("Expected one but no recordings were found.")
        }
    }
    
    func testHandleRecordTimePlates() throws {
        viewModel.handleAddPlate()
        XCTAssertEqual(viewModel.recordings.first?.timestamp, Date(timeIntervalSince1970: 0.0))
        XCTAssertEqual(viewModel.recordings.count, 1)
        viewModel.handleRecordTime()
        XCTAssertEqual(viewModel.recordings.count, 1)
        XCTAssertNotEqual(viewModel.recordings.first?.timestamp, Date(timeIntervalSince1970: 0.0))
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
    
    func testHandleSelectRecordingSelect() throws {
        let expected = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try viewModel.persistenceController.saveRecording(recording: expected, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertNil(viewModel.selectedRecording)
        
        viewModel.handleSelectRecording(expected)
        
        XCTAssertEqual(expected, viewModel.selectedRecording)
    }
    
    func testHandleSelectRecordingToggle() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try viewModel.persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.handleSelectRecording(recording)
        viewModel.handleSelectRecording(recording)
        
        XCTAssertNil(viewModel.selectedRecording)
    }
    
    func testHandleSelectRecordingSwitch() throws {
        let recording1 = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recording2 = Recording(id: UUID(), plate: "321", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try viewModel.persistenceController.saveRecording(recording: recording1, listId: recordingList.id)
            try viewModel.persistenceController.saveRecording(recording: recording2, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.handleSelectRecording(recording1)
        XCTAssertEqual(recording1, viewModel.selectedRecording)
        
        viewModel.handleSelectRecording(recording2)
        XCTAssertEqual(recording2, viewModel.selectedRecording)
    }
    
    func testHandleAppendPlateDigit() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))

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
    
    func testHandleAppendPlateDigitInvalidDigitOver() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))

        do {
            try viewModel.persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.updateRecordings()
        
        viewModel.handleSelectRecording(recording)
        
        viewModel.handleAppendPlateDigit(10)
        
        XCTAssertEqual(viewModel.recordings.count, 1)
        
        if let recording = viewModel.recordings.first {
            XCTAssertEqual(recording.plate, "123")
        }
    }
    
    func testHandleAppendPlateDigitInvalidDigitUnder() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))

        do {
            try viewModel.persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        viewModel.updateRecordings()
        
        viewModel.handleSelectRecording(recording)
        
        viewModel.handleAppendPlateDigit(-1)
        
        XCTAssertEqual(viewModel.recordings.count, 1)
        
        if let recording = viewModel.recordings.first {
            XCTAssertEqual(recording.plate, "123")
        }
    }
    
    func testHandleRemoveLastPlateDigit() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))

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
    
    func testHandleRemoveLastPlateDigitEmpty() throws {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))

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
            XCTAssertEqual(recording.plate, "")
        }
    }
    
    func testHandleDeleteRecording() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))

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
