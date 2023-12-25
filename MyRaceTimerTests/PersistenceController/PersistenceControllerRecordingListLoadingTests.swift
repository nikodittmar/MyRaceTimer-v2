//
//  PersistenceControllerRecordingListLoadingTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/24/23.
//

import XCTest
@testable import MyRaceTimer

final class PersistenceControllerRecordingListLoadingTests: XCTestCase {
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
    
    func testFetchLoadedRecordingError() throws {
        XCTAssertThrowsError(try persistenceController.fetchLoadedRecordingList())
    }
    
    func testLoadRecordingList() throws {
        XCTAssertNoThrow(try persistenceController.loadRecordingList(id: recordingList.id))
        
        let loadedRecordingList = try persistenceController.fetchLoadedRecordingList()
        
        XCTAssertEqual(loadedRecordingList.id, recordingList.id)
    }
    
    func testLoadRecordingListSwitching() throws {
        XCTAssertNoThrow(try persistenceController.loadRecordingList(id: recordingList.id))
        
        let loadedRecordingList1 = try persistenceController.fetchLoadedRecordingList()
        
        XCTAssertEqual(loadedRecordingList1.id, recordingList.id)
        
        let recordingList2 = RecordingList(id: UUID(), name: "two", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
        
        do {
            try persistenceController.saveRecordingList(recordingList2)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        
        XCTAssertNoThrow(try persistenceController.loadRecordingList(id: recordingList2.id))
        
        let loadedRecordingList2 = try persistenceController.fetchLoadedRecordingList()
        
        XCTAssertEqual(loadedRecordingList2.id, recordingList2.id)
    }
    

}
