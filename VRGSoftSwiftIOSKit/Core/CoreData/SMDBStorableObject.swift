//
//  SMDBStorableObject.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import CoreData

public protocol SMDBStorableObject: NSManagedObject {
    static var defaultStorage: SMDBStorage { get }
    static var dafaultSortDescriptors: [NSSortDescriptor] { get }
    static var primaryKey: String { get }
    static var keyId: String { get }
    static var _entityName: String { get }
    func setupPrimaryKeyWithDictionary(_ aData: [String: Any], context aContext: NSManagedObjectContext)
    func setupWithDictionary(_ aData: [String: Any], context aContext: NSManagedObjectContext)
}

public extension SMDBStorableObject {
    
    static var defaultStorage: SMDBStorage {
        if let storage: SMDBStorage = SMDBStorageConfigurator.storage {
            return storage
        } else {
            assert(false, "Need register storage class in configurator. Use registerStorageClass(:) of SMDBStorageConfigurator")
            return SMDBStorage()
        }
    }
    
    var _identifier: Any? {
        set {
            setValue(newValue, forKey: primaryKey)
        }
        get {
            return value(forKey: primaryKey) as Any
        }
    }
    
    static var dafaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: primaryKey, ascending: true)]
    }
    
    var primaryKey: String {
        return Self.primaryKey
    }
    
    static var primaryKey: String {
        return "identifier"
    }
    
    static var keyId: String {
        return "id"
    }
    
    static var _entityName: String {
        
        let entityName: String? = {
            
            if #available(iOS 10.0, *) {
                return entity().name
            } else {
                return nil
            }
        }()
        
        if let entityName: String = entityName {
            return entityName
        } else {
            assert(false, "Override this method in subclasses before iOS 10!")
            return ""
        }
    }
    
    func setupWithDictionary(_ aData: [String: Any], context aContext: NSManagedObjectContext) {
        return
    }
    
    func setupPrimaryKeyWithDictionary(_ aData: [String: Any], context aContext: NSManagedObjectContext) {
        _identifier = aData[type(of: self).keyId]
    }
    
    private func setupWithData(_ aData: [String: Any], context aContext: NSManagedObjectContext) {
        setupPrimaryKeyWithDictionary(aData, context: aContext)
        setupWithDictionary(aData, context: aContext)
    }
    
    static func objectByID(_ objID: Any?) -> Self? {
        
        var object: Self?
        
        if let objID: Any = objID {
            
            defaultStorage.defaultContextAndWait (block: { aContext in
                do {
                    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
                    
                    if let objID: String = objID as? String {
                        request.predicate = NSPredicate(format: "%K LIKE[c] %@", primaryKey, objID)
                    }
                    
                    if objID is Int || objID is NSNumber {
                        request.predicate = NSPredicate(format: "self.\(primaryKey) == \(objID)")
                    }
                    
                    let array: [Self]? = try aContext.fetch(request) as? [Self]
                    object = array?.last
                } catch {
                    
                }
            })
        }
        
        return object
    }
    
    static func objectsByAttributePredicate(_ attribute: String, _ value: Any, sortDescriptors: [NSSortDescriptor]? = nil) -> [Self] {
        
        var array: [Self] = []
        
        defaultStorage.defaultContextAndWait (block: { aContext in
            do {
                let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
                request.sortDescriptors = sortDescriptors ?? dafaultSortDescriptors
                request.predicate = NSPredicate(format: "self.\(attribute) == \(value)")
                array = try aContext.fetch(request) as? [Self] ?? []
            } catch {
                
            }
        })
        
        return array
    }
    
    static func objectsWithPredicate(_ predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]? = nil) -> [Self] {
        
        var array: [Self] = []
        
        defaultStorage.defaultContextAndWait (block: { aContext in
            do {
                let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
                request.sortDescriptors = sortDescriptors ?? dafaultSortDescriptors
                request.predicate = predicate
                array = try aContext.fetch(request) as? [Self] ?? []
            } catch {
                
            }
        })
        
        return array
    }
    
    static func allObjects() -> [Self] {
        
        var array: [Self] = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        fetchRequest.sortDescriptors = dafaultSortDescriptors
        
        defaultStorage.defaultContextAndWait (block: { aContext in
            do {
                let fetchedEntities: [Self] = try aContext.fetch(fetchRequest) as? [Self] ?? []
                array = fetchedEntities
            } catch {
                
            }
        })
        
        return array
    }
    
    func cloneTempObject() -> Self? {
        
        let object: Self? = Self.defaultStorage.clone(object: self) as? Self
        
        return object
    }
    
    static func makeObjectTemp() -> Self? {
        
        var result: Self?
        
        defaultStorage.defaultContextAndWait (block: { aContext in
            if let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: _entityName, in: aContext) {
                result = (self as NSManagedObject.Type).init(entity: entity, insertInto: aContext) as? Self
            }
            
        })
        
        return result
    }
    
    static func makeObjectContext(context aContext: NSManagedObjectContext) -> Self? {
        
        var result: Self?
        
        if let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: _entityName, in: aContext) {
            result = (self as NSManagedObject.Type).init(entity: entity, insertInto: aContext) as? Self
        }
        
        return result
    }
    
    @discardableResult static func makeOrUpdateObjectWithData(_ aData: Any?) -> Self? {
        
        var result: Self?
        
        if let aData: Any = aData {
            
            if aData is NSNumber || aData is String || aData is NSString {
                
                result = objectByID(aData)
                
                if result == nil {
                    
                    defaultStorage.saveAndWait(block: { aContext in
                        result = makeObjectContext(context: aContext)
                        result?._identifier = aData as? NSNumber
                    }, completion: {
                        result = result?.inContext(defaultStorage.defaultContext)
                    })
                }
                
            } else if let data: [String: Any] = aData as? [String: Any] {
                
                result = objectByID(data[keyId])
                
                defaultStorage.saveAndWait(block: { aContext in
                    
                    if result == nil {
                        result = makeObjectContext(context: aContext)
                    } else {
                        result = result?.inContext(aContext)
                    }
                    
                    result?.setupWithData(data, context: aContext)
                    
                }, completion: {
                    result = result?.inContext(defaultStorage.defaultContext)
                })
            }
        }
        
        
        return result
    }
    
    static func makeOrUpdateObjectWithData(_ aData: Any?, inContext aContext: NSManagedObjectContext) -> Self? {
        
        var result: Self?
        
        if aData is NSNumber || aData is String || aData is NSString {
            
            result = objectByID(aData)
            
            if result == nil {
                
                result = makeObjectContext(context: aContext)
                
                result?._identifier = aData
                
            } else {
                result = result?.inContext(aContext)
            }
        } else if let data: [String: Any] = aData as? [String: Any] {
            
            result = objectByID(data[keyId])
            
            if result == nil {
                result = makeObjectContext(context: aContext)
            } else {
                result = result?.inContext(aContext)
            }
            
            result?.setupWithData(data, context: aContext)
        }
        
        return result
    }
    
    /// Make or update (if exist) objects in the specified NSManagedObjectContext
    ///
    /// - Parameters:
    ///   - aData: data to make or update (if exist) objects
    ///   - aContext: specified NSManagedObjectContext for save
    /// - Returns: Array of NSManagedObjects in the specified NSManagedObjectContext
    @discardableResult static func mergeWithData(_ aData: Any, inContext aContext: NSManagedObjectContext) -> [Self] {
        
        var result: [Self] = []
        
        if let datas: [Any] = aData as? [Any] {
            
            for data: Any in datas {
                
                if let obj: Self = makeOrUpdateObjectWithData(data, inContext: aContext) {
                    result.append(obj)
                }
            }
            
        } else {
            
            if let obj: Self = makeOrUpdateObjectWithData(aData, inContext: aContext) {
                result.append(obj)
            }
        }
        
        return result
    }
    
    /// Make or update (if exist) objects in the default (mainQueueConcurrencyType) NSManagedObjectContext
    ///
    /// - Parameters:
    /// - aData: data to make or update (if exist) objects
    /// - Returns: Array of NSManagedObjects in the default (mainQueueConcurrencyType) NSManagedObjectContext
    @discardableResult static func mergeWithDataDefault(_ aData: Any) -> [Self] {
        
        var result: [Self] = []
        
        defaultStorage.saveAndWait(block: { aContext in
            
            result = mergeWithData(aData, inContext: aContext)
            
        }, completion: {
            result = result.moveToContext(defaultStorage.defaultContext)
        })
        
        return result
    }
    
    /// Make or update (if exist) objects in the specified NSManagedObjectContext
    ///
    /// - Parameters:
    ///   - aData: data to make or update (if exist) objects
    ///   - aContext: specified NSManagedObjectContext for save
    ///   - aOldObjects: Array of NSManagedObjects for update. Unused will be removed
    /// - Returns: Array of NSManagedObjects in the specified NSManagedObjectContext
    @discardableResult static func mergeWithData(_ aData: Any, inContext aContext: NSManagedObjectContext, oldObjects aOldObjects: [Self]?) -> [Self] {
        
        let result: [Self] = mergeWithData(aData, inContext: aContext)
        
        if let oldObjects: [Self] = aOldObjects?.moveToContext(aContext),
            !oldObjects.isEmpty {
            
            var willRemoveObjects: [Self] = []
            
            for obj: Self in oldObjects {
                
                var isContain: Bool = false
                
                for newobj: Self in result {
                    
                    if obj.isEqual(newobj) {
                        
                        isContain = true
                        break
                    }
                }
                
                if !isContain {
                    willRemoveObjects.append(obj)
                }
            }
            
            defaultStorage.remove(objects: willRemoveObjects)
        }
        
        return result
    }
    
    /// Make or update (if exist) objects in the default (mainQueueConcurrencyType) NSManagedObjectContext
    ///
    /// - Parameters:
    ///   - aData: data to make or update (if exist) objects
    ///   - aOldObjects: Array of NSManagedObjects for update. Unused will be removed
    /// - Returns: Array of NSManagedObjects in the specified NSManagedObjectContext
    @discardableResult static func mergeWithDataDefault(_ aData: Any, oldObjects aOldObjects: [Self]?) -> [Self] {
        
        var result: [Self] = []
        
        defaultStorage.saveAndWait(block: { aContext in
            
            result = mergeWithData(aData, inContext: aContext, oldObjects: aOldObjects)
            
        }, completion: {
            result = result.moveToContext(defaultStorage.defaultContext)
        })
        
        return result
    }
    
    static func objectsReqWith(offset: Int, limit: Int, predicate: NSPredicate? = nil) -> SMDBRequest {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        
        request.predicate = predicate
        request.fetchOffset = offset
        request.fetchLimit = limit
        request.sortDescriptors = dafaultSortDescriptors
        
        let result: SMDBRequest = SMDBRequest(storage: defaultStorage, fetchRequest: request)
        return result
    }
    
    static func objectsReqWithPredicate(_ predicate: NSPredicate) -> SMDBRequest {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        request.sortDescriptors = dafaultSortDescriptors
        request.predicate = predicate
        
        let result: SMDBRequest = SMDBRequest(storage: defaultStorage, fetchRequest: request)
        
        return result
    }
    
    static func allObjectsReq() -> SMDBRequest {
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        request.sortDescriptors = dafaultSortDescriptors
        
        let result: SMDBRequest = SMDBRequest(storage: defaultStorage, fetchRequest: request)
        
        return result
    }
    
    static func objectsBtIds(ids: [Any]?) -> [Self] {
        
        if let ids: [Any] = ids {
            
            var result: [Self] = [Self]()
            
            for id: Any in ids {
                
                if let object: Self = objectByID(id) {
                    result.append(object)
                }
            }
            
            return result
            
        } else {
            return [Self]()
        }
    }
    
    static func ids(objects: [Self]) -> [Any?] {
        
        return objects.compactMap { object -> Any? in
            return object._identifier }
    }
}
