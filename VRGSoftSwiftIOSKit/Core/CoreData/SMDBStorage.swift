//
//  SMStorage.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 12/26/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import CoreData

public typealias SMStorageContextBlock = (NSManagedObjectContext) -> Void
public typealias SMStorageVoidBlock = () -> Void

public enum SMClonePolicy {
    
    case asOriginal
    case asTemp
    case insertIntoDefaultContext
}

open class SMDBStorage {
    
    private var _defaultContext: NSManagedObjectContext?
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var _managedObjectModel: NSManagedObjectModel?
    
    open var shouldCacheStorage: Bool = false
    
    public required init() {
        
        _ = defaultContext
    }

    open var defaultContext: NSManagedObjectContext {
        
        if let defaultContext: NSManagedObjectContext = _defaultContext {
            
            return defaultContext
        } else {
            
            let defaultContext: NSManagedObjectContext = createDefaultContext(coordinator: persistentStoreCoordinator)
            _defaultContext = defaultContext
            return defaultContext
        }
    }

    open var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        
        if let persistentStoreCoordinator: NSPersistentStoreCoordinator = _persistentStoreCoordinator {
            
            return persistentStoreCoordinator
        } else {
            
            let persistentStoreCoordinator: NSPersistentStoreCoordinator = createPersistentStoreCoordinator(managedObjectModel)
            _persistentStoreCoordinator = persistentStoreCoordinator
            
            return persistentStoreCoordinator
        }
    }

    open var managedObjectModel: NSManagedObjectModel {
        
        if let managedObjectModel: NSManagedObjectModel = _managedObjectModel {
            
            return managedObjectModel
        } else {
            
            let managedObjectModel: NSManagedObjectModel = createManagedObjectModel()
            _managedObjectModel = managedObjectModel
            
            return managedObjectModel
        }
    }

    
    // MARK: - Create
    
    open func createDefaultContext(coordinator aCoordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        
        let result: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        result.persistentStoreCoordinator = aCoordinator
        result.mergePolicy = NSOverwriteMergePolicy
        result.undoManager = nil
        
        return result
    }
    
    open func createPersistentStoreCoordinator(_ objectModel: NSManagedObjectModel) -> NSPersistentStoreCoordinator {
        
        let fileManager: FileManager = FileManager.default
        
        guard let directoryURL: URL = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last,
            let persistentStoreName: String = persistentStoreName() else {
            assert(true, #function + " persistentStoreName " + String(describing: self))
            return NSPersistentStoreCoordinator()
        }
        
        var storeUrl: URL = NSURL.fileURL(withPath: persistentStoreName, relativeTo: directoryURL)
        
        storeUrl.setTemporaryResourceValue(self.shouldCacheStorage, forKey: URLResourceKey.isExcludedFromBackupKey)
        
        let result: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try result.addPersistentStore(ofType: self.storeType(), configurationName: nil, at: storeUrl, options: self.migrationPolicy())
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    open func createManagedObjectModel() -> NSManagedObjectModel {
        
        var result: NSManagedObjectModel
        
        if self.mergeModels() {
            
            if let mergedModel: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) {
                
                result = mergedModel
            } else {
                
                assert(true, #function + String(describing: self))
                result = NSManagedObjectModel()
            }
        } else {
            
            if let name: String = self.persistentStoreName()?.replacingOccurrences(of: ".sqlite", with: ""),
                let modelPath: String = Bundle.main.path(forResource: name, ofType: "momd") {
                
                let modelURL: URL = URL(fileURLWithPath: modelPath)
                
                if let managedObjectModel: NSManagedObjectModel = NSManagedObjectModel(contentsOf: modelURL) {
                    
                    result = managedObjectModel
                } else {
                    
                    assert(true, #function + String(describing: self))
                    result = NSManagedObjectModel()
                }
            } else {
                
                assert(true, #function + String(describing: self))
                result = NSManagedObjectModel()
            }
        }
        
        return result
    }

    
    // MARK: - Config
    
    open func storeType() -> String {
        
        return NSSQLiteStoreType
    }
    
    open func persistentStoreName() -> String? {
        
        return nil
    }
    
    open func migrationPolicy() -> [AnyHashable: Any]? {
        
        return [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    }
    
    open func mergeModels() -> Bool {
        
        return true
    }
    
    
    // MARK: - Context
    
    open var savingContext: NSManagedObjectContext {
        
        return contextWithParent(defaultContext)
    }
    
    open func contextWithParent(_ aParentContext: NSManagedObjectContext) -> NSManagedObjectContext {
        
        let result: NSManagedObjectContext = createPrivateQueueContext
        result.parent = aParentContext
        
        return result
    }
    
    open var createPrivateQueueContext: NSManagedObjectContext {
        
        let result: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        return result
    }

    
    // MARK: - Save
    
    open func save(context aContext: NSManagedObjectContext) {
        
        if aContext.hasChanges {
            
            do {
                try aContext.save()
                
                if let parent: NSManagedObjectContext = aContext.parent {
                    
                    save(context: parent)
                }
            } catch _ as NSError {
                
                #if DEBUG
                    abort()
                #else
                    aContext.rollback()
                #endif
            }
        }
    }

    open func save(block aBlock: @escaping SMStorageContextBlock, completion aCompletion: SMStorageVoidBlock? = nil) {
        
        let savingContext: NSManagedObjectContext = self.savingContext
        
        savingContext.perform {
            aBlock(savingContext)
            
            self.save(context: savingContext)
            
            if let completion: SMStorageVoidBlock = aCompletion {
                
                completion()
            }
        }
    }
    
    open func saveAndWait(block aBlock: SMStorageContextBlock, completion aCompletion: SMStorageVoidBlock? = nil) {
        
        let savingContext: NSManagedObjectContext = self.savingContext
        
        savingContext.performAndWait {
            
            aBlock(savingContext)
            self.save(context: savingContext)
            
            if let completion: SMStorageVoidBlock = aCompletion {
                
                completion()
            }
        }
    }

    
    // MARK: - Perform blocks
    
    open func defaultContext(block aBlock: @escaping SMStorageContextBlock) {
        
        defaultContext.perform {
            
            aBlock(self.defaultContext)
        }
    }

    open func defaultContextAndWait(block aBlock: @escaping SMStorageContextBlock) {
        
        defaultContext.performAndWait {
            
            aBlock(self.defaultContext)
        }
    }

    
    // MARK: Remove entities
    
    open func removeAllEntitiesWithName(_ anEntityName: String) {
        
        self.saveAndWait(block: { context in
            let entitiesRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
            entitiesRequest.entity = NSEntityDescription.entity(forEntityName: anEntityName, in: context)
            entitiesRequest.includesPropertyValues = false
            
            var aError: Error?
            var entities: [AnyObject]
            
            do {
                entities = try context.fetch(entitiesRequest)
                
                for object: AnyObject in entities {
                    
                    if let object: NSManagedObject = object as? NSManagedObject {
                        
                        context.delete(object)
                    }
                }
            } catch {
                
                aError = error
            }
            
            if aError != nil {
                
                print("STStorage: remove entities with error: \(String(describing: aError))")
            }
        })
    }

    open func remove(object aObject: NSManagedObject) {
        
        self.saveAndWait(block: { context in
            
            if let obj: NSManagedObject = aObject.inContext(context) {
                
                context.delete(obj)
            }
        })
    }
    
    open func remove(objects aObjects: [NSManagedObject]) {
        
        self.saveAndWait(block: { context in
            
            for object: NSManagedObject in aObjects {
                
                if let obj: NSManagedObject = object.inContext(context) {
                    
                    context.delete(obj)
                }
            }
        })
    }
    
    
    // MARK: - Clear

    open func clear() {
        
        self.save(block: { context in
            self.clearIn(context: context)
        }, completion: nil)
    }
    
    open func clearAndWait() {
        
        self.saveAndWait(block: { context in
            self.clearIn(context: context)
        }, completion: nil)
    }

    open func clearIn(context aContext: NSManagedObjectContext) {
        
        let allEntities: [NSEntityDescription] = self.managedObjectModel.entities

        for entityDescription: NSEntityDescription in allEntities {
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            fetchRequest.entity = entityDescription
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false

            do {
                let items: [Any] = try aContext.fetch(fetchRequest)

                for managedObject: Any in items where managedObject is NSManagedObject {
                    
                    if let managedObject: NSManagedObject = managedObject as? NSManagedObject {
                        
                        aContext.delete(managedObject)
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    
    // MARK: - Clone
    
    open func clone(object aObject: NSManagedObject, clonePolicy aClonePolicy: SMClonePolicy = SMClonePolicy.asTemp) -> NSManagedObject? {
        
        guard let entityName: String = aObject.entity.name,
            let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName, in: self.defaultContext) else {
            return nil
        }
        
        var result: NSManagedObject
        
        switch aClonePolicy {
        case SMClonePolicy.asOriginal:
            result = (type(of: aObject) as NSManagedObject.Type).init(entity: entity, insertInto: aObject.managedObjectContext)
        case SMClonePolicy.asTemp:
            result = (type(of: aObject) as NSManagedObject.Type).init(entity: entity, insertInto: nil)
        case SMClonePolicy.insertIntoDefaultContext:
            result = (type(of: aObject) as NSManagedObject.Type).init(entity: entity, insertInto: self.defaultContext)
        }
        
        let attributes: [String: NSAttributeDescription] = entity.attributesByName
        
        for attributeName: (key: String, value: NSAttributeDescription) in attributes {
            
            result.setValue(aObject.value(forKey: attributeName.key), forKey: attributeName.key)
        }
        
        return result
    }
}
