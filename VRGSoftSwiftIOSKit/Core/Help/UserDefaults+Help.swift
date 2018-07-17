//
//  UserDefaults+Help.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 3/29/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import Foundation

//aCoding have to inherit from NSObject
public extension UserDefaults
{
    public func setCoding(_ aCoding: NSCoding, forKey aKey: String)
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: aCoding)
        self.set(data, forKey: aKey)
    }
    
    public func coding<T: NSCoding>(forKey aKey: String) -> T?
    {
        var result: T? = nil
        
        let data: Any? = self.object(forKey: aKey)
        
        if let data = data as? Data
        {
            result = NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        
        return result
    }
}