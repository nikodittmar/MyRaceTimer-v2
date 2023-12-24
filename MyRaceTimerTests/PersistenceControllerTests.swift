//
//  PersistenceControllerTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/22/23.
//

import XCTest
@testable import MyRaceTimer

final class PersistenceControllerTests: XCTestCase {
    var persistenceController: PersistenceController!
    
    override func setUp() {
        persistenceController = PersistenceController(inMemory: true)
    }
    
    // Should create recordingList.
    func testCreateRecordingList() throws {
        let expected = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .finish, recordings: [])
        
        do {
            try persistenceController.createRecordingList(expected)
        } catch {
            XCTFail("createRecordingList() threw an error unexpectedly.")
        }
        
        let recordingLists = persistenceController.fetchRecordingLists()
        
        guard (recordingLists.count == 1) else {
            XCTFail("Expected 1 recordingList but \(recordingLists.count) recordingLists were returned.")
            return
        }
        
        if let result = recordingLists.first {
            XCTAssertEqual(result, expected)
        } else {
            XCTFail()
        }
    }
    
    // Should return recordingLists sorted by updatedDate in ascending order.
    func testFetchRecordingListsOrder() throws {
        let expected = [
            RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000003), type: .finish, recordings: []),
            RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000002), type: .finish, recordings: []),
            RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000001), type: .finish, recordings: []),
        ]
        
        do {
            try persistenceController.createRecordingList(expected[2])
            try persistenceController.createRecordingList(expected[0])
            try persistenceController.createRecordingList(expected[1])
        } catch {
            XCTFail("createRecordingList() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordingLists()
        
        guard (result.count == 3) else {
            XCTFail("Expected 3 recordingList but \(result.count) recordingLists were returned.")
            return
        }
        
        XCTAssertEqual(result, expected)
    }
    
    // Should create recording.
    func testCreateRecording() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
        do {
            try persistenceController.createRecordingList(recordingList)
        } catch {
            XCTFail("createRecordingList() threw an error unexpectedly.")
        }
        
        let expected = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000))
        
        do {
            try persistenceController.createRecording(recording: expected, list: recordingList)
        } catch {
            XCTFail("createRecording() threw and error unexpectedly.")
        }
        
        let recordings = persistenceController.fetchRecordings(list: recordingList)
        
        guard (recordings.count == 1) else {
            XCTFail("Expected 1 recording but \(recordings.count) recordings were returned.")
            return
        }
        
        if let result = recordings.first {
            XCTAssertEqual(result, expected)
        } else {
            XCTFail()
        }
    }
    
    // Should return recordings sorted by timestamp in ascending order.
    func testFetchRecordingsOrder() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
        do {
            try persistenceController.createRecordingList(recordingList)
        } catch {
            XCTFail("createRecordingList() threw an error unexpectedly.")
        }
        
        let expected = [
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000003)),
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000002)),
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000001)),
        ]
        
        do {
            try persistenceController.createRecording(recording: expected[2], list: recordingList)
            try persistenceController.createRecording(recording: expected[0], list: recordingList)
            try persistenceController.createRecording(recording: expected[1], list: recordingList)
        } catch {
            XCTFail("createRecordingList() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordings(list: recordingList)
        
        guard (result.count == 3) else {
            XCTFail("Expected 3 recording but \(result.count) recordings were returned.")
            return
        }
        
        XCTAssertEqual(result, expected)
    }
    
}
