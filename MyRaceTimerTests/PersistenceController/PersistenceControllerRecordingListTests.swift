//
//  PersistenceControllerRecordingListTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/24/23.
//

import XCTest
@testable import MyRaceTimer

final class PersistenceControllerRecordingListTests: XCTestCase {
    var persistenceController: PersistenceController!
    
    override func setUp() {
        persistenceController = PersistenceController(inMemory: true)
    }
    
    // Should create recordingList.
    func testCreateRecordingList() throws {
        let expected = [RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .finish, recordings: [])]
        
        do {
            try persistenceController.saveRecordingList(expected[0])
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordingLists()
        
        XCTAssertEqual(expected, result)
    }
    
    func testCreateRecordingListCreatesRecordings() throws {
        let recording1 = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recording2 = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording1, recording2])
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        XCTAssertNotNil(persistenceController.fetchRecording(id: recording1.id))
        XCTAssertNotNil(persistenceController.fetchRecording(id: recording2.id))
    }
    
    func testCreateAlreadyExistingRecordingList() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        XCTAssertThrowsError(try persistenceController.saveRecordingList(recordingList))
    }
    
    func testCreateRecordingListWithExistingRecordings() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recordingList1 = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        let recordingList2 = RecordingList(id: UUID(), name: "two", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        
        do {
            try persistenceController.saveRecordingList(recordingList1)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        XCTAssertThrowsError(try persistenceController.saveRecordingList(recordingList2))
    }
    
    // Should return recordingLists sorted by updatedDate in ascending order.
    func testFetchRecordingListsOrder() throws {
        let expected = [
            RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000003), type: .finish, recordings: []),
            RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000002), type: .finish, recordings: []),
            RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000001), type: .finish, recordings: []),
        ]
        
        do {
            try persistenceController.saveRecordingList(expected[2])
            try persistenceController.saveRecordingList(expected[0])
            try persistenceController.saveRecordingList(expected[1])
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordingLists()
                
        XCTAssertEqual(result, expected)
    }
    
    func testUpdateRecordingListName() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .finish, recordings: [])
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.updateRecordingListName(id: recordingList.id, name: "recording list")
        } catch {
            XCTFail("updateRecordingListName() threw an error unexpectedly.")
        }
        
        let recordingLists = persistenceController.fetchRecordingLists()
                
        if let result = recordingLists.first {
            XCTAssert(result.name == "recording list")
        } else {
            XCTFail("Expected one but no recordingLists were returned.")
        }
    }
    
    func testUpdateRecordingListType() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .finish, recordings: [])
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.updateRecordingListType(id: recordingList.id, type: .start)
        } catch {
            XCTFail("updateRecordingListType() threw an error unexpectedly.")
        }
        
        let recordingLists = persistenceController.fetchRecordingLists()
                
        if let result = recordingLists.first {
            XCTAssert(result.type == .start)
        } else {
            XCTFail("Expected one but no recordingLists were returned.")
        }
    }
    
    func testDeleteRecordingList() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .finish, recordings: [])
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.deleteRecordingList(id: recordingList.id)
        } catch {
            XCTFail("deleteRecordingList() threw an error unexpectedly.")
        }
        
        let result = persistenceController.fetchRecordingLists()
                
        XCTAssert(result.isEmpty)
    }
}
