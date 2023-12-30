//
//  RecordingsViewModelTests.swift
//  MyRaceTimerTests
//
//  Created by Niko Dittmar on 12/28/23.
//

import XCTest
@testable import MyRaceTimer

@MainActor final class RecordingsViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var viewModel: RecordingsViewModel!
    var recordingList: RecordingList = RecordingList(id: UUID(), name: "", createdDate: Date(timeIntervalSince1970: 1700000000), updatedDate: Date(timeIntervalSince1970: 1700000000), type: .start, recordings: [])
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        
        do {
            try persistenceController.saveRecordingList(recordingList)
        } catch {
            XCTFail("saveRecordingList() threw an error unexpectedly.")
        }
        do {
            try persistenceController.loadRecordingList(id: recordingList.id)
        } catch {
            XCTFail("loadRecordingList() threw an error unexpectedly.")
        }
        
        viewModel = RecordingsViewModel(persistenceController: persistenceController)
    }
    
    func testUpdateRecordingListName() throws {
        let name: String = "test"
        viewModel.name = name
        viewModel.updateRecordingListName()
        let loadedRecordingList = try? viewModel.persistenceController.fetchLoadedRecordingList()
        XCTAssertEqual(loadedRecordingList?.name, name)
    }
    
    func testUpdateRecordingListType() throws {
        let type: RecordingListType = .finish
        viewModel.type = type
        viewModel.updateRecordingListType()
        let loadedRecordingList = try? viewModel.persistenceController.fetchLoadedRecordingList()
        XCTAssertEqual(loadedRecordingList?.type, type)
    }
    
    func testHasDuplicatePlatesDuplicates() throws {
        let recordings = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)), Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        do {
            try persistenceController.saveRecording(recording: recordings[0], listId: recordingList.id)
            try persistenceController.saveRecording(recording: recordings[1], listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertTrue(viewModel.presentingDuplicatePlateWarning())
    }
    
    func testPresentingDuplicatePlatesEmpty() throws {
        let recordings = [Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)), Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        do {
            try persistenceController.saveRecording(recording: recordings[0], listId: recordingList.id)
            try persistenceController.saveRecording(recording: recordings[1], listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.presentingDuplicatePlateWarning())
    }
    
    func testPresentingDuplicatePlatesNoDuplicates() throws {
        let recordings = [Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000)), Recording(id: UUID(), plate: "456", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))]
        do {
            try persistenceController.saveRecording(recording: recordings[0], listId: recordingList.id)
            try persistenceController.saveRecording(recording: recordings[1], listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.presentingDuplicatePlateWarning())
    }
    
    func testPresentingMissingPlatesMissing() throws {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertTrue(viewModel.presentingMissingPlateWarning())
    }
    
    func testPresentingMissingPlatesNotMissing() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.presentingMissingPlateWarning())
    }
    
    func testPresentingMissingTimestampsMissing() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 0), createdDate: Date(timeIntervalSince1970: 1700000000))
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertTrue(viewModel.presentingMissingTimestampWarning())
    }
    
    func testPresentingMissingTimestampsNotMissing() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.presentingMissingTimestampWarning())
    }
    
    func testRecordingListIsEmptyEmpty() throws {
        XCTAssertTrue(viewModel.recordingListIsEmpty())
    }
    
    func testRecordingListIsEmptyWithName() throws {
        do {
            try persistenceController.updateRecordingListName(id: recordingList.id, name: "test")
        } catch {
            XCTFail("updateRecordingListName() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.recordingListIsEmpty())
    }
    
    func testRecordingListIsEmptyWithRecording() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        do {
            try persistenceController.updateRecordingListName(id: recordingList.id, name: "")
        } catch {
            XCTFail("updateRecordingListName() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.recordingListIsEmpty())
    }
    
    func testRecordingListIsEmptyWithRecordingAndName() throws {
        let recording = Recording(id: UUID(), plate: "123", timestamp: Date(timeIntervalSince1970: 1700000000), createdDate: Date(timeIntervalSince1970: 1700000000))
        do {
            try persistenceController.saveRecording(recording: recording, listId: recordingList.id)
        } catch {
            XCTFail("saveRecording() threw an error unexpectedly.")
        }
        
        XCTAssertFalse(viewModel.recordingListIsEmpty())
    }
}
