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
    
    let updateRecordings: () -> Void
    let deactivateTimer: () -> Void
    
    let recordingListId: UUID?
    
    @Published var name: String
    @Published var type: RecordingListType
    
    @Published var dismiss: Bool = false
    
    @Published var presentingDeleteRecordingListWarning: Bool = false
    
    init(updateRecordings: @escaping () -> Void, deactivateTimer: @escaping () -> Void) {
        persistenceController = PersistenceController.shared
        if let recordingList = try? persistenceController.fetchLoadedRecordingList() {
            name = recordingList.name
            type = recordingList.type
            recordingListId = recordingList.id
        } else {
            name = ""
            type = .start
            recordingListId = nil
        }
        self.updateRecordings = updateRecordings
        self.deactivateTimer = deactivateTimer
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
        
        self.updateRecordings = {}
        self.deactivateTimer = {}
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
        
    }
    
    func otherRecordingLists() -> [RecordingList] {
        return persistenceController.fetchRecordingLists().filter {
            $0.id != recordingListId
        }
    }
    
    func selectRecordingList(id: UUID) {
        
    }
    
    func deleteRecordingList() {
        
    }
}
