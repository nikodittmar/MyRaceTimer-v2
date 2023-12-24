//
//  RecordingListModel+CoreDataProperties.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/23/23.
//
//

import Foundation
import CoreData


extension RecordingListModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordingListModel> {
        return NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var type: String?
    @NSManaged public var id: UUID?
    @NSManaged public var recordings: NSSet?
    
    public var unwrappedId: UUID {
        id ?? UUID()
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedCreatedDate: Date {
        createdDate ?? Date(timeIntervalSince1970: 0.0)
    }
    
    public var unwrappedUpdatedDate: Date {
        updatedDate ?? Date(timeIntervalSince1970: 0.0)
    }
    
    public var unwrappedType: RecordingListType {
        RecordingListType(rawValue: type ?? "") ?? .start
    }
    
    public var recordingsArray: [Recording] {
        let set = recordings as? Set<RecordingModel> ?? []
        
        let recordingModels = set.sorted {
            $0.unwrappedTimestamp > $1.unwrappedTimestamp
        }
        
        return recordingModels.map {
            Recording(id: $0.unwrappedId, plate: $0.unwrappedPlate, timestamp: $0.unwrappedTimestamp)
        }
    }

}

// MARK: Generated accessors for recordings
extension RecordingListModel {

    @objc(addRecordingsObject:)
    @NSManaged public func addToRecordings(_ value: RecordingModel)

    @objc(removeRecordingsObject:)
    @NSManaged public func removeFromRecordings(_ value: RecordingModel)

    @objc(addRecordings:)
    @NSManaged public func addToRecordings(_ values: NSSet)

    @objc(removeRecordings:)
    @NSManaged public func removeFromRecordings(_ values: NSSet)

}

extension RecordingListModel : Identifiable {

}
