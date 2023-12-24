//
//  PersistenceController.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/21/23.
//

import Foundation
import CoreData

enum PersistenceControllerError: Error {
    case errorSaving
    case recordingListNotFound
}

class PersistenceController {

    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyRaceTimer")
        
        if (inMemory) {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error Loading Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func createRecording(recording: Recording, list: RecordingList) throws {
        let recordingModel = RecordingModel(context: container.viewContext)
        recordingModel.id = recording.id
        recordingModel.plate = recording.plate
        recordingModel.timestamp = recording.timestamp
        
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        
        do {
            recordingModel.recordingList = try container.viewContext.fetch(fetchRequest).first
        } catch {
            throw PersistenceControllerError.recordingListNotFound
        }
        
        do {
            try container.viewContext.save()
        } catch {
            throw PersistenceControllerError.errorSaving
        }
    }
    
    func createRecordingList(_ recordingList: RecordingList) throws {
        let recordingListModel = RecordingListModel(context: container.viewContext)
        recordingListModel.id = recordingList.id
        recordingListModel.name = recordingList.name
        recordingListModel.type = recordingList.type.rawValue
        recordingListModel.createdDate = recordingList.createdDate
        recordingListModel.updatedDate = recordingList.updatedDate
        
        do {
            try container.viewContext.save()
        } catch {
            throw PersistenceControllerError.errorSaving
        }
    }
    
    func fetchRecordings(list: RecordingList) -> [Recording]{
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        
        do {
            return try container.viewContext.fetch(fetchRequest).first?.recordingsArray ?? []
        } catch {
            return []
        }
    }
    
    func fetchRecordingLists() -> [RecordingList] {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let recordingListModels = try container.viewContext.fetch(fetchRequest)
            return recordingListModels.map {
                RecordingList(id: $0.unwrappedId, name: $0.unwrappedName, createdDate: $0.unwrappedCreatedDate, updatedDate: $0.unwrappedUpdatedDate, type: $0.unwrappedType, recordings: $0.recordingsArray)
            }
        } catch {
            return []
        }
    }
    
}
