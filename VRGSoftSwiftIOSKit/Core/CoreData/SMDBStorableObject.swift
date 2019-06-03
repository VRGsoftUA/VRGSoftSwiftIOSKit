//
//  SMDBStorableObject.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import CoreData

public protocol SMDBStorableObject {
    func inContext(_ aContext: NSManagedObjectContext) -> Self?
}

public extension SMDBStorableObject where Self: NSManagedObject {
    
    func inContext(_ aContext: NSManagedObjectContext) -> Self? {
        
        var result: NSManagedObject?
        
        do {
            try managedObjectContext?.obtainPermanentIDs(for: [self])
            aContext.performAndWait {
                result = aContext.object(with: objectID)
            }
        } catch {
            
        }
        
        return result as? Self
    }
}
