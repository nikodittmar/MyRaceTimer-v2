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

public struct RecordingList: Equatable {
    var id: UUID
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
}
