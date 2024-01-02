//
//  RecordingList.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/23/23.
//

import Foundation
import UniformTypeIdentifiers

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
    
    func csvString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy H:mm:ss.SS"
        
        var csvString: String = ""
        
        for recording in recordings {
            let timeStampString = recording.timestamp == Date(timeIntervalSince1970: 0.0) ? "" : dateFormatter.string(from: recording.timestamp)
            
            csvString.append("\(recording.plate),\(timeStampString)\n")
        }
        
        return csvString
    }
    
    func fileName() -> String {
        return "\(name)-\(type.rawValue.capitalized)"
    }
}

extension RecordingList: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case createdDate
        case updatedDate
        case type
        case recordings
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try values.decode(String.self, forKey: .name)
        createdDate = try values.decode(Date.self, forKey: .createdDate)
        updatedDate = try values.decode(Date.self, forKey: .updatedDate)
        type = try values.decode(RecordingListType.self, forKey: .type)
        recordings = try values.decode(Array<Recording>.self, forKey: .recordings)
    }
}

public enum RecordingListType: String, Codable {
    case start = "Start"
    case finish = "Finish"
}

extension UTType {
    static var recordingList: UTType { UTType(exportedAs: "com.nikodittmar.MyRaceTimer.recordinglist") }
}

