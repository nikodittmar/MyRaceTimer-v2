//
//  RecordingListTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/29/23.
//

import XCTest
@testable import MyRaceTimer

final class RecordingListTests: XCTestCase {

    func testHasDuplicatePlatesDuplicate() throws {
        let recordings = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)), Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: recordings)
        
        XCTAssertTrue(recordingList.hasDuplicatePlates())
    }
    
    func testHasDuplicatePlatesEmpty() throws {
        let recordings = [Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)), Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: recordings)
        
        XCTAssertFalse(recordingList.hasDuplicatePlates())
    }
    
    func testHasDuplicatePlatesDifferent() throws {
        let recordings = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)), Recording(id: UUID(), plate: "456", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: recordings)
        
        XCTAssertFalse(recordingList.hasDuplicatePlates())
    }
    
    func testHasMissingTimestampsMissing() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 0), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        
        XCTAssertTrue(recordingList.hasMissingTimestamps())
    }
    
    func testHasMissingTimestampsNotMissing() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        
        XCTAssertFalse(recordingList.hasMissingTimestamps())
    }
    
    func testHasMissingPlatesMissing() throws {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        
        XCTAssertTrue(recordingList.hasMissingPlates())
    }
    
    func testHasMissingPlatesNotMissing() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        
        XCTAssertFalse(recordingList.hasMissingPlates())
    }
    
    func testIsEmptyEmpty() throws {
        let recordingList = RecordingList(id: UUID(), name: "", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
        
        XCTAssertTrue(recordingList.isEmpty())
    }
    
    func testIsEmptyNotEmpty() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [recording])
        
        XCTAssertFalse(recordingList.isEmpty())
    }
    
    func testFileNameStart() throws {
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
        let fileName = recordingList.fileName()
        
        XCTAssertEqual(fileName, "test-Start")
    }
    
    func testFileNameFinish() throws {
        let recordingList = RecordingList(id: UUID(), name: "Recording", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .finish, recordings: [])
        let fileName = recordingList.fileName()
        
        XCTAssertEqual(fileName, "Recording-Finish")
    }
    
    func testCSVString() throws {
        let recordings = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000.52), createdDate: Date(timeIntervalSince1970: 1700000000.52)), Recording(id: UUID(), plate: "456", timestamp: Date(timeIntervalSince1970: 1700000021.33), createdDate: Date(timeIntervalSince1970: 1700000021.33)), Recording(id: UUID(), plate: "789", timestamp: Date(timeIntervalSince1970: 1700000045.91), createdDate: Date(timeIntervalSince1970: 1700000045.91))]
        let recordingList = RecordingList(id: UUID(), name: "test", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: recordings)
        
        let csvString = recordingList.csvString()
    
        let expected = "123,11-14-2023 14:13:20.52\n456,11-14-2023 14:13:41.33\n789,11-14-2023 14:14:05.91\n"
        
        XCTAssertEqual(csvString, expected)
    }
}
