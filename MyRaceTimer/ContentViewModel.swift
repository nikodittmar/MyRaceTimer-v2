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
    @Published var selectedRecording: Recording? = nil
    
    @Published var upcomingPlate: String = ""
    @Published var upcomingPlateSelected: Bool = false
    
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
    }
    
    func updateRecordings() {
        
    }
    
    func handleRecordTime() {
        
    }
    
    func handleAddPlate() {
        
    }
    
    func handleSelectRecording(_ recording: Recording) {
        
    }
    
    func handleSelectUpcomingPlate() {
        
    }
    
    func handleAppendPlateDigit(_ digit: Int) {
        
    }
    
    func handleRemoveLastPlateDigit() {
        
    }
    
    func handleDeleteRecording() {
        
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
