//
//  UserDefaults+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 3/29/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import Foundation

//aCoding have to inherit from NSObject
public extension SMWrapper where Base: UserDefaults {

    func setCoding(_ aCoding: NSCoding, forKey aKey: String) {
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: aCoding)
        base.set(data, forKey: aKey)
    }
    
    func coding<T: NSCoding>(forKey aKey: String) -> T? {
        
        var result: T?
        
        let data: Any? = base.object(forKey: aKey)
        
        if let data: Data = data as? Data {
            result = NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        
        return result
    }
}


extension UserDefaults: SMCompatible { }
