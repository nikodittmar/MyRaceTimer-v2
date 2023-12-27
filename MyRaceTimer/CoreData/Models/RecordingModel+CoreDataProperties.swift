//
//  RecordingModel+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/23/23.
//
//

import Foundation
import CoreData


extension RecordingModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordingModel> {
        return NSFetchRequest<RecordingModel>(entityName: "RecordingModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var plate: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var createdDate: Date?
    @NSManaged public var recordingList: RecordingListModel?
    
    public var unwrappedId: UUID {
        id ?? UUID()
    }
    
    public var unwrappedPlate: String {
        plate ?? ""
    }
    
    public var unwrappedTimestamp: Date {
        timestamp ?? Date(timeIntervalSince1970: 0.0)
    }
    
    public var unwrappedCreatedDate: Date {
        createdDate ?? Date(timeIntervalSince1970: 0.0)
    }
}

extension RecordingModel : Identifiable {

}
