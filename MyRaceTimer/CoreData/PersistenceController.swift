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
    case noLoadedRecordingListFound
    case errorFetching
    case idAlreadyExists
}

class PersistenceController {

    static let shared = PersistenceController()
    static let tests = PersistenceController(inMemory: true)
    
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
        
        guard let recordingListModels = try? container.viewContext.fetch(fetchRequest) else {
            throw PersistenceControllerError.errorFetching
        }
        
        guard let loadedModel = recordingListModels.first(where: { $0.loaded }) else {
            throw PersistenceControllerError.noLoadedRecordingListFound
        }
        
        return RecordingList(
            id: loadedModel.unwrappedId,
            name: loadedModel.unwrappedName,
            createdDate: loadedModel.unwrappedCreatedDate,
            updatedDate: loadedModel.unwrappedUpdatedDate, 
            type: loadedModel.unwrappedType,
            recordings: loadedModel.recordingsArray
        )
    }
    
    func loadRecordingList(id: UUID) throws {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        
        
        guard let recordingListModels = try? container.viewContext.fetch(fetchRequest) else {
            throw PersistenceControllerError.errorFetching
        }
        
        if let loadedModel = recordingListModels.first(where: { $0.loaded }) {
            loadedModel.setValue(false, forKey: "loaded")
        }
        
        guard let modelToLoad = recordingListModels.first(where: { $0.unwrappedId == id }) else {
            throw PersistenceControllerError.recordingListNotFound
        }
    
        modelToLoad.setValue(true, forKey: "loaded")
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            throw PersistenceControllerError.errorSaving
        }
    }
    
    // MARK: RecordingModel
    
    func saveRecording(recording: Recording, listId: UUID) throws {
        guard fetchRecording(id: recording.id) == nil else {
            throw PersistenceControllerError.idAlreadyExists
        }
        
        let recordingModel = RecordingModel(context: container.viewContext)
        recordingModel.id = recording.id
        recordingModel.plate = recording.plate
        recordingModel.timestamp = recording.timestamp
        recordingModel.createdDate = recording.createdDate
        
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
    
    func fetchRecording(id: UUID) -> Recording? {
        let fetchRequest = NSFetchRequest<RecordingModel>(entityName: "RecordingModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let recordingModel = try? container.viewContext.fetch(fetchRequest).first
        
        if let recording = recordingModel {
            return Recording(id: recording.unwrappedId, plate: recording.unwrappedPlate, timestamp: recording.unwrappedTimestamp, createdDate: recording.unwrappedCreatedDate)
        } else {
            return nil
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
        guard fetchRecordingList(id: recordingList.id) == nil else {
            throw PersistenceControllerError.idAlreadyExists
        }
        
        let recordingListModel = RecordingListModel(context: container.viewContext)
        
        recordingListModel.id = recordingList.id
        recordingListModel.name = recordingList.name
        recordingListModel.type = recordingList.type.rawValue
        recordingListModel.createdDate = recordingList.createdDate
        recordingListModel.updatedDate = recordingList.updatedDate
        recordingListModel.loaded = false
        
        for recording in recordingList.recordings {
            guard fetchRecording(id: recording.id) == nil else {
                throw PersistenceControllerError.idAlreadyExists
            }
            let recordingModel = RecordingModel(context: container.viewContext)
            recordingModel.id = recording.id
            recordingModel.createdDate = recording.createdDate
            recordingModel.plate = recording.plate
            recordingModel.timestamp = recording.timestamp
        }
        
        do {
            try container.viewContext.save()
        } catch {
            throw PersistenceControllerError.errorSaving
        }
    }
    
    func fetchRecordingList(id: UUID) -> RecordingList? {
        let fetchRequest = NSFetchRequest<RecordingListModel>(entityName: "RecordingListModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let recordingListModel = try? container.viewContext.fetch(fetchRequest).first
        if let list = recordingListModel {
            return RecordingList(id: list.unwrappedId, name: list.unwrappedName, createdDate: list.unwrappedCreatedDate, updatedDate: list.unwrappedUpdatedDate, type: list.unwrappedType, recordings: list.recordingsArray)
        } else {
            return nil
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
