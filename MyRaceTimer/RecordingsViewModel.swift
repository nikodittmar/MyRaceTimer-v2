//
//  RecordingsViewModel.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/29/23.
//

import Foundation
import SwiftUI

@MainActor class RecordingsViewModel: ObservableObject {
    
    let persistenceController: PersistenceController
    
    let recordingListId: UUID?
    
    @Published var name: String
    @Published var type: RecordingListType
    
    @Published var presentingDeleteRecordingListWarning: Bool = false
    @Published var presentingShareSheet: Bool = false
    
    @Published var fileToShareURL: [URL] = []
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("-testing") {
            persistenceController = PersistenceController.tests
        } else {
            persistenceController = PersistenceController.shared
        }
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            name = recordingList.name
            type = recordingList.type
            recordingListId = recordingList.id
        } else {
            name = ""
            type = .start
            recordingListId = nil
        }
    }
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            name = recordingList.name
            type = recordingList.type
            recordingListId = recordingList.id
        } else {
            name = ""
            type = .start
            recordingListId = nil
        }
    }
    
    func updateRecordingListName() {
        if let id = recordingListId {
            try? persistenceController.updateRecordingListName(id: id, name: name)
        }
    }
    
    func updateRecordingListType() {
        if let id = recordingListId {
            try? persistenceController.updateRecordingListType(id: id, type: type)
        }
    }
    
    func presentingDuplicatePlateWarning() -> Bool {
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            return recordingList.hasDuplicatePlates()
        } else {
            return false
        }
    }
    
    func presentingMissingPlateWarning() -> Bool {
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            return recordingList.hasMissingPlates()
        } else {
            return false
        }
    }
    
    func presentingMissingTimestampWarning() -> Bool {
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            return recordingList.hasMissingTimestamps()
        } else {
            return false
        }
    }
    
    func recordingListIsEmpty() -> Bool {
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            return recordingList.name.isEmpty && recordingList.recordings.isEmpty
        } else {
            return false
        }
    }
    
    func createRecordingList() {
        let recordingList = RecordingList(id: UUID(), name: "", createdDate: Date.now, updatedDate: Date.now, type: .start, recordings: [])
        do {
            if recordingListIsEmpty(), let recordingListId = recordingListId {
                try persistenceController.deleteRecordingList(id: recordingListId)
            }
            try persistenceController.saveRecordingList(recordingList)
            try persistenceController.loadRecordingList(id: recordingList.id)
        } catch {
            return
        }
    }
    
    func otherRecordingLists() -> [RecordingList] {
        return persistenceController.fetchRecordingLists().filter {
            $0.id != recordingListId
        }
    }
    
    func selectRecordingList(id: UUID) {
        do {
            if recordingListIsEmpty(), let recordingListId = recordingListId {
                try persistenceController.deleteRecordingList(id: recordingListId)
            }
            try persistenceController.loadRecordingList(id: id)
        } catch {
            return
        }
    }
    
    func deleteRecordingList() {
        let recordingList = RecordingList(id: UUID(), name: "", createdDate: Date.now, updatedDate: Date.now, type: .start, recordings: [])
        do {
            try persistenceController.saveRecordingList(recordingList)
            try persistenceController.loadRecordingList(id: recordingList.id)
            if let recordingListId = recordingListId {
                try persistenceController.deleteRecordingList(id: recordingListId)
            }
        } catch {
            return
        }
    }
    
    func exportCSVFile() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let selectedRecordingList = try? persistenceController.fetchLoadedRecordingList() {
            let data = selectedRecordingList.csvString()
            let fileName = selectedRecordingList.fileName()
            let fileURL = paths[0].appendingPathComponent(fileName, conformingTo: .commaSeparatedText)
            try? FileManager.default.removeItem(at: fileURL)
            do {
                try data.write(to: fileURL, atomically: true, encoding: .utf8)
                fileToShareURL = [fileURL]
                presentingShareSheet = true
            } catch {
                return
            }
        }
    }
}
