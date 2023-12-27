//
//  RecordingTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/25/23.
//

import XCTest
@testable import MyRaceTimer

final class RecordingTests: XCTestCase {
    
    func testTimestampString() throws {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000.12), createdDate: Date(timeIntervalSince1970: 1700000000.12))
        let expected = "14:13:20.12"
        let result = recording.timestampString()
        XCTAssertEqual(expected, result)
    }
    
    func testTimestampStringEmpty() throws {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 0.0), createdDate: Date(timeIntervalSince1970: 1700000000))
        let expected = "--:--:--.--"
        let result = recording.timestampString()
        XCTAssertEqual(expected, result)
    }
    
    func testPlateLabel() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let expected = "123"
        let result = recording.plateLabel()
        XCTAssertEqual(expected, result)
    }
    
    func testPlateLabelEmpty() throws {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        let expected = "-       -"
        let result = recording.plateLabel()
        XCTAssertEqual(expected, result)
    }
    
    func testDuplicatePlateWithDuplicate() throws {
        let recordings = [
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "456", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "789", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
        ]
        
        XCTAssertTrue(recordings[0].hasDuplicatePlateIn(recordings))
    }
    
    func testDuplicatePlateNoDuplicate() throws {
        let recordings = [
            Recording(id: UUID(), plate: "111", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "222", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "333", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "444", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
        ]
        
        XCTAssertFalse(recordings[0].hasDuplicatePlateIn(recordings))
    }
    
    func testDuplicatePlateEmpty() throws {
        let recordings = [
            Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "333", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
            Recording(id: UUID(), plate: "444", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)),
        ]
        
        XCTAssertFalse(recordings[0].hasDuplicatePlateIn(recordings))
    }
}
