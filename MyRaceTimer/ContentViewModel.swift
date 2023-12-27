//
//  ContentViewModel.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/25/23.
//

import Foundation
import SwiftUI

@MainActor class ContentViewModel: ObservableObject {
    let persistenceController: PersistenceController
    
    @Published var recordings: [Recording] = []
    @Published var selectedRecordingId: UUID? = nil
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    var secondsSinceLastRecording: Double = 0.0
    
    @Published var timeElapsedString: String = "0s"
    @Published var timerIsActive: Bool = false
    
    init(forTesting: Bool = false) {
        if (forTesting) {
            self.persistenceController = PersistenceController(inMemory: true)
        } else {
            self.persistenceController = PersistenceController.shared
        }
        if ((try? persistenceController.fetchLoadedRecordingList()) == nil) {
            let recordingList = RecordingList(id: UUID(), name: "", createdDate: Date.now, updatedDate: Date.now, type: .start, recordings: [])
            try? persistenceController.saveRecordingList(recordingList)
            try? persistenceController.loadRecordingList(id: recordingList.id)
        }
        updateRecordings()
    }
    
    func updateRecordings() {
        if let loadedRecordingList = try? persistenceController.fetchLoadedRecordingList() {
            recordings = persistenceController.fetchRecordings(listId: loadedRecordingList.id)
        }
    }
    
    func handleRecordTime() {
        let currentTime = Date.now
        let recordingsWithoutTimestamps = recordings.filter {
            $0.timestamp == Date(timeIntervalSince1970: 0.0)
        }
        if recordingsWithoutTimestamps.isEmpty {
            let recording = Recording(id: UUID(), plate: "", timestamp: currentTime, createdDate: currentTime)
            if let loadedRecordingList = try? persistenceController.fetchLoadedRecordingList() {
                try? persistenceController.saveRecording(recording: recording, listId: loadedRecordingList.id)
                handleSelectRecording(recording)
                recordings = persistenceController.fetchRecordings(listId: loadedRecordingList.id)
            }
        } else {
            for recording in recordingsWithoutTimestamps {
                try? persistenceController.updateRecordingTimestamp(id: recording.id, timestamp: currentTime)
                updateRecordings()
            }
        }
        
        resetTimer()
        timerIsActive = true
    }
    
    func handleAddPlate() {
        let recording = Recording(id: UUID(), plate: "", timestamp: Date(timeIntervalSince1970: 0.0), createdDate: Date.now)
        if let loadedRecordingList = try? persistenceController.fetchLoadedRecordingList() {
            try? persistenceController.saveRecording(recording: recording, listId: loadedRecordingList.id)
            handleSelectRecording(recording)
            recordings = persistenceController.fetchRecordings(listId: loadedRecordingList.id)
        }
    }
    
    func handleSelectRecording(_ recording: Recording) {
        if (selectedRecordingId == nil || recording.id != selectedRecordingId) {
            selectedRecordingId = recording.id
        } else {
            selectedRecordingId = nil
        }
    }
    
    func handleAppendPlateDigit(_ digit: Int) {
        guard (digit >= 0 && digit <= 9) else {
            return
        }
        guard let recording = recordings.first(where: { $0.id == selectedRecordingId }) else {
            return
        }
        let plate = recording.plate + String(digit)
        if plate.count <= 6 {
            try? persistenceController.updateRecordingPlate(id: recording.id, plate: plate)
            updateRecordings()
        }
    }
    
    func handleRemoveLastPlateDigit() {
        guard let recording = recordings.first(where: { $0.id == selectedRecordingId }) else {
            return
        }
        if recording.plate.count >= 1 {
            try? persistenceController.updateRecordingPlate(id: recording.id, plate: String(recording.plate.dropLast()))
            updateRecordings()
        }
    }
    
    func handleDeleteRecording() {
        guard let recording = recordings.first(where: { $0.id == selectedRecordingId }) else {
            return
        }
        try? persistenceController.deleteRecording(id: recording.id)
        updateRecordings()
    }
    
    // MARK: Elapsed Timer
    
    func updateTime() {
        secondsSinceLastRecording += 1.0
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(secondsSinceLastRecording)) ?? ""
        timeElapsedString = formattedString
    }
    
    func resetTimer() {
        secondsSinceLastRecording = 0.0
        timeElapsedString = "0s"
        timerIsActive = true
    }
    
    func deactivateTimer() {
        timerIsActive = false
    }
}
