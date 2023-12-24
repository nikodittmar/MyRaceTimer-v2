//
//  Recording.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/22/23.
//

import Foundation

public struct Recording: Equatable {
    var id: UUID
    var plate: String
    var timestamp: Date
    
    init(plate: String, timestamp: Date) {
        self.id = UUID()
        self.plate = plate
        self.timestamp = timestamp
    }
    
    init(id: UUID, plate: String, timestamp: Date) {
        self.id = id
        self.plate = plate
        self.timestamp = timestamp
    }
}
