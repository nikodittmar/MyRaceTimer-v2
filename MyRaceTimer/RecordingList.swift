//
//  RecordingList.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/23/23.
//

import Foundation

public enum RecordingListType: String {
    case start = "Start"
    case finish = "Finish"
}

public struct RecordingList: Equatable, Identifiable {
    public var id: UUID
    var name: String
    var createdDate: Date
    var updatedDate: Date
    var type: RecordingListType
    var recordings: [Recording]
    
    init(id: UUID, name: String, createdDate: Date, updatedDate: Date, type: RecordingListType, recordings: [Recording]) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.type = type
        self.recordings = recordings
    }
    
    func hasDuplicatePlates() -> Bool {
        let recordingsWithPlates = recordings.filter {
            $0.plate != ""
        }
        let plateFrequencies = Dictionary(grouping: recordingsWithPlates, by: { $0.plate })
        let duplicateCount = plateFrequencies.filter {
            $1.count > 1
        }
        return !duplicateCount.isEmpty
    }
    
    func hasMissingPlates() -> Bool {
        for recording in recordings {
            if recording.plate == "" {
                return true
            }
        }
        return false
    }
    
    func hasMissingTimestamps() -> Bool {
        for recording in recordings {
            if recording.timestamp == Date(timeIntervalSince1970: 0.0) {
                return true
            }
        }
        return false
    }
    
    func isEmpty() -> Bool {
        return recordings.isEmpty && name.isEmpty
    }
    
    func issueCount() -> Int {
        var count = 0
        if hasDuplicatePlates() { count += 1 }
        if hasMissingPlates() { count += 1 }
        if hasMissingTimestamps() { count += 1 }
        return count
    }
}
