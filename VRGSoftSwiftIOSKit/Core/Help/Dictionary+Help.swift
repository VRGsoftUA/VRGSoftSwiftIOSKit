//
//  Dictionary+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/22/19.
//  Copyright © 2019 OLEKSANDR SEMENIUK. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    fileprivate mutating func setValueIfNotNil(value aValue: Value?, key aKey: Key) {
        
        if let value: Value = aValue {
            
            self[aKey] = value
        }
    }
    
    private mutating func setStringIfNotNilAndNotEmpty(value aValue: String?, key aKey: Key) {
        
        if let value: String = aValue {
            
            if !value.isEmpty {
                
                if let value: Value = value as? Value {
                    
                    self[aKey] = value
                }
            }
        }
    }
    
    private mutating func setValueNilProtect(value aValue: Value?, key aKey: Key) {
        
        var value: Value? = aValue
        
        if value == nil {
            
            value = NSNull() as? Value
        }
        
        if let value: Value = aValue {
            
            self[aKey] = value
        }
    }
}
