//
//  SMDBStorableObject+SMDBRequest.swift
//  VRGSoftSwiftIOSKit
//
//  Created by developer on 05.03.2020.
//  Copyright © 2020 OLEKSANDR SEMENIUK. All rights reserved.
//

import CoreData
import VRGSoftIOSDBKit

public extension SMDBStorableObject where Self: NSManagedObject {
    
    static func objectsReqWith(offset: Int, limit: Int, predicate: NSPredicate? = nil) -> SMDBRequest {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        
        request.predicate = predicate
        request.fetchOffset = offset
        request.fetchLimit = limit
        request.sortDescriptors = defaultSortDescriptors
        
        let result: SMDBRequest = SMDBRequest(storage: defaultStorage, fetchRequest: request)
        return result
    }
    
    static func objectsReqWithPredicate(_ predicate: NSPredicate) -> SMDBRequest {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = predicate
        
        let result: SMDBRequest = SMDBRequest(storage: defaultStorage, fetchRequest: request)
        
        return result
    }
    
    static func allObjectsReq() -> SMDBRequest {
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        request.sortDescriptors = defaultSortDescriptors
        
        let result: SMDBRequest = SMDBRequest(storage: defaultStorage, fetchRequest: request)
        
        return result
    }
}
