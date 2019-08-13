//
//  Array+NSManagedObjectContext.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import CoreData

public extension Array where Element: NSManagedObject {
    
    func moveToContext(_ aContext: NSManagedObjectContext) -> [Element] {
        
        var result: [Element] = []
        
        for obj: Element in self {
            
            if let newObj: Element = obj.inContext(aContext) {
                result.append(newObj)
            }
        }
        
        return result
    }
}

extension NSManagedObject {
    
    func inContext(_ aContext: NSManagedObjectContext) -> Self? {
        return inContext(aContext, type: type(of: self))
    }
    
    private func inContext<T>(_ aContext: NSManagedObjectContext, type: T.Type) -> T? {
        var result: T?
        
        do {
            try managedObjectContext?.obtainPermanentIDs(for: [self])
            aContext.performAndWait {
                result = aContext.object(with: objectID) as? T
            }
        } catch {
            
        }
        
        return result
    }
}
