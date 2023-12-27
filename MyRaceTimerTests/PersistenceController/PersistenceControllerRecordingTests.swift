//
//  PersistenceControllerRecordingTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/24/23.
//

import XCTest
@testable import MyRaceTimer

final class PersistenceControllerRecordingTests: XCTestCase {
    var persistenceController: PersistenceController!
    var recordingList: RecordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
    }
    
    // Should create recording.
    func testCreateRecording() throws {
        let expected = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        
        do {
            try persistenceController.saveRecording(recording: expected[0], listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordings(listId: recordingList.id)
        
        XCTAssertEqual(expected, result)
    }
    
    // Should return recordings sorted by timestamp in ascending order.
    func testFetchRecordingsOrder() throws {
        let expected = [
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000001), createdDate: Date(timeIntervalSince1970: 1700000003)),
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000002), createdDate: Date(timeIntervalSince1970: 1700000002)),
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000003), createdDate: Date(timeIntervalSince1970: 1700000001)),
        ]
        
        do {
            try persistenceController.saveRecording(recording: expected[2], listId: recordingList.id)
            try persistenceController.saveRecording(recording: expected[0], listId: recordingList.id)
            try persistenceController.saveRecording(recording: expected[1], listId: recordingList.id)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordings(listId: recordingList.id)
        
        XCTAssertEqual(result, expected)
    }
    
    func testUpdateRecordingPlate() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.updateRecordingPlate(id: recording.id, plate: "321")
        } catch {
            XCTFail("updateRecordingPlate() threw an error unexpectedly.")
        }
        
        let fetchedRecordings = persistenceController.fetchRecordings(listId: recordingList.id)
        
        if let result = fetchedRecordings.first {
            XCTAssert(result.plate == "321")
        } else {
            XCTFail("Expected one but no recordings were returned.")
        }
        
    }
    
    func testUpdateRecordingType() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 0), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.updateRecordingTimestamp(id: recording.id, timestamp: Date(timeIntervalSince1970: 1700000000))
        } catch {
            XCTFail("updateRecordingTimestamp() threw an error unexpectedly.")
        }
        
        let fetchedRecordings = persistenceController.fetchRecordings(listId: recordingList.id)
        
        if let result = fetchedRecordings.first {
            XCTAssert(result.timestamp == Date(timeIntervalSince1970: 1700000000))
        } else {
            XCTFail("Expected one but no recordings were returned.")
        }
        
    }
    
    func testDeleteRecording() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.deleteRecording(id: recording.id)
        } catch {
            XCTFail("deleteRecording() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordings(listId: recordingList.id)
                
        XCTAssert(result.isEmpty)
    }
}
