//
//  Array+NSManagedObjectContext.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import CoreData

public extension Array where Element: SMDBStorableObject {
    
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
