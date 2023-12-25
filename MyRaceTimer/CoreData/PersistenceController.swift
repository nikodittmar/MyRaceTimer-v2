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
    case recordingNotFound
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
    
    // MARK: RecordingList Loading
    
    func fetchLoadedRecordingList() throws -> RecordingList {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "loaded == %@", true as NSNumber)
        
        if let recordingListModel = try? container.viewContext.fetch(fetchRequest).first {
            return RecordingList(
                id: recordingListModel.unwrappedId,
                name: recordingListModel.unwrappedName,
                createdDate: recordingListModel.unwrappedCreatedDate,
                updatedDate: recordingListModel.unwrappedUpdatedDate,
                type: recordingListModel.unwrappedType,
                recordings: recordingListModel.recordingsArray
            )
        } else {
            throw PersistenceControllerError.recordingNotFound
        }
    }
    
    func loadRecordingList(id: UUID) throws {
        let oldFetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        oldFetchRequest.predicate = NSPredicate(format: "loaded == %@", true as NSNumber)
        
        let newFetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        newFetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let oldRecordingListModel = try? container.viewContext.fetch(oldFetchRequest).first,
            let newRecordingListModel = try? container.viewContext.fetch(newFetchRequest).first {
            oldRecordingListModel.setValue(false, forKey: "loaded")
            newRecordingListModel.setValue(true, forKey: "loaded")
            
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingNotFound
        }
    }
    
    // MARK: RecordingModel
    
    func saveRecording(recording: Recording, listId: UUID) throws {
        let recordingModel = RecordingModel(context: container.viewContext)
        recordingModel.id = recording.id
        recordingModel.plate = recording.plate
        recordingModel.timestamp = recording.timestamp
        
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", listId as CVarArg)
        
        guard let recordingListModel = try? container.viewContext.fetch(fetchRequest).first else {
            throw PersistenceControllerError.recordingListNotFound
        }
        
        recordingModel.recordingList = recordingListModel
        
        do {
            try container.viewContext.save()
        } catch {
            throw PersistenceControllerError.errorSaving
        }
    }
    
    func fetchRecordings(listId: UUID) -> [Recording]{
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", listId as CVarArg)
        
        do {
            return try container.viewContext.fetch(fetchRequest).first?.recordingsArray ?? []
        } catch {
            return []
        }
    }
    
    func updateRecordingPlate(id: UUID, plate: String) throws {
        let fetchRequest = NSFetchRequest<RecordingModel>(entityName: "RecordingModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let recordingModel = try? container.viewContext.fetch(fetchRequest).first {
            recordingModel.setValue(plate, forKey: "plate")
            
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingNotFound
        }
    }
    
    func updateRecordingTimestamp(id: UUID, timestamp: Date) throws {
        let fetchRequest = NSFetchRequest<RecordingModel>(entityName: "RecordingModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let recordingModel = try? container.viewContext.fetch(fetchRequest).first {
            recordingModel.setValue(timestamp, forKey: "timestamp")
            
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingNotFound
        }
    }
    
    func deleteRecording(id: UUID) throws {
        let fetchRequest = NSFetchRequest<RecordingModel>(entityName: "RecordingModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let recordingModel = try? container.viewContext.fetch(fetchRequest).first {
            container.viewContext.delete(recordingModel)
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingNotFound
        }
    }
    
    // MARK: RecordingListModel
    
    func saveRecordingList(_ recordingList: RecordingList) throws {
        let recordingListModel = RecordingListModel(context: container.viewContext)
        
        recordingListModel.id = recordingList.id
        recordingListModel.name = recordingList.name
        recordingListModel.type = recordingList.type.rawValue
        recordingListModel.createdDate = recordingList.createdDate
        recordingListModel.updatedDate = recordingList.updatedDate
        recordingListModel.loaded = false
        
        do {
            try container.viewContext.save()
        } catch {
            throw PersistenceControllerError.errorSaving
        }
    }
    
    func fetchRecordingLists() -> [RecordingList] {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let recordingListModels = try container.viewContext.fetch(fetchRequest)
            return recordingListModels.map {
                RecordingList(
                    id: $0.unwrappedId,
                    name: $0.unwrappedName,
                    createdDate: $0.unwrappedCreatedDate,
                    updatedDate: $0.unwrappedUpdatedDate,
                    type: $0.unwrappedType,
                    recordings: $0.recordingsArray
                )
            }
        } catch {
            return []
        }
    }
    
    func updateRecordingListName(id: UUID, name: String) throws {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let recordingListModel = try? container.viewContext.fetch(fetchRequest).first {
            recordingListModel.setValue(name, forKey: "name")
            recordingListModel.setValue(Date.now, forKey: "updatedDate")
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingListNotFound
        }
    }
    
    func updateRecordingListType(id: UUID, type: RecordingListType) throws {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let recordingListModel = try? container.viewContext.fetch(fetchRequest).first {
            recordingListModel.setValue(type.rawValue, forKey: "type")
            recordingListModel.setValue(Date.now, forKey: "updatedDate")
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingListNotFound
        }
    }
    
    func deleteRecordingList(id: UUID) throws {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let recordingListModel = try? container.viewContext.fetch(fetchRequest).first {
            container.viewContext.delete(recordingListModel)
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                throw PersistenceControllerError.errorSaving
            }
        } else {
            throw PersistenceControllerError.recordingListNotFound
        }
    }
}
