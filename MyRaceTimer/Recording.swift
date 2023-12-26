//
//  Recording.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/22/23.
//

import Foundation

public struct Recording: Equatable, Identifiable {
    public var id: UUID
    public var plate: String
    public var timestamp: Date
        
    init(id: UUID, plate: String, timestamp: Date) {
        self.id = id
        self.plate = plate
        self.timestamp = timestamp
    }
    
    func timestampString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss.SS"
        if timestamp == Date(timeIntervalSince1970: 0.0) {
            return "--:--:--.--"
        } else {
            return dateFormatter.string(from: timestamp)
        }
    }
    
    func plateLabel() -> String {
        return plate == "" ? "-       -" : plate
    }
    
    func hasDuplicatePlateIn(_ recordings: [Recording]) -> Bool {
        if plate.isEmpty {
            return false
        }
        
        let plates = recordings.map {
            $0.plate
        }
        var count = 0
        for plate in plates {
            if plate == self.plate {
                count += 1
            }
        }
        
        return count > 1
    }
}
