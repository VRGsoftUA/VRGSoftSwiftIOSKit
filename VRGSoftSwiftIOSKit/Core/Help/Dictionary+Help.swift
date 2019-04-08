//
//  Dictionary+Help.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/17/18.
//  Copyright © 2018 OLEKSANDR SEMENIUK. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {

    /**
     
     Use this method to access values in *inner dictionaries*
     
     - Parameter keyPath: describes a keypath to elemet you want to access(see example)
     - Parameter separator: describes a delimeter between keypath's parts, for example in keypath **user.settings.avatar** *delimeter* is **dot symbol(.)**, by default, it equals **dot symbol(.)**
     
     **USAGE EXAMPLE:**
     
     if you have dictionary like **userDictionary**(example below):
     
     ```
     let avatarDictionary: [String: Any] = ["avatarURL": "someUrl", "dataCount": 1024]
     let settingsDictionary: [String: Any] = ["avatar": avatarDictionary]
     let userDictionary: [String: Any] = ["settings": settingsDictionary]
     
     ```
     
     and you want to access value of avatarURL key of the avatarDictionary,
     you can easy see that this element has **path - "settings.avatar.avatarURL"** throught the dictionaries.
     This path is **keyPath**
     
     to access element you need, see the code below:
     
     ```
     let avatarURL: String? = userDictionary.value(forKeyPath: "settings.avatar") as? String
     
     ```
     
     */
    
    public func value(forKeyPath keyPath: String, separator: String = ".") -> Any? {
        
        var result: Any?
        
        if !keyPath.contains(Character(separator)) {
            
            result = self[keyPath]
        } else {
            
            var nodes: [String.SubSequence] = keyPath.split(separator: Character(separator))
            
            if nodes.isEmpty {
                
                result = self[keyPath]
            } else {
                
                if let rootObject: Any = self[String(nodes[0])] {
                    
                    if nodes.count == 1 {
                        
                        result = rootObject
                    } else {
                        
                        if let dictionary: [String: Any] = rootObject as? [String: Any] {
                            
                            nodes = Array(nodes[1..<nodes.count])
                            
                            var newKeyPath: String = String()
                            
                            nodes.forEach { node in
                                
                                newKeyPath.append(contentsOf: String(node))
                                
                                if node != nodes.last {
                                    
                                    newKeyPath.append(contentsOf: separator)
                                }
                            }
                            
                            result = dictionary.value(forKeyPath: newKeyPath)
                        } else {
                            
                            result = rootObject
                        }
                    }
                } else {
                    
                    result = nil
                }
            }
        }
        
        return result
    }
}


public extension Dictionary {
    
    public mutating func setValueIfNotNil(value aValue: Value?, key aKey: Key) {
        
        if let value: Value = aValue {
            
            self[aKey] = value
        }
    }
    
    public mutating func setStringIfNotNilAndNotEmpty(value aValue: String?, key aKey: Key) {
        
        if let value: String = aValue {
            
            if !value.isEmpty {
                
                if let value: Value = value as? Value {
                    
                    self[aKey] = value
                }
            }
        }
    }
    
    public mutating func setValueNilProtect(value aValue: Value?, key aKey: Key) {
        
        var value: Value? = aValue
        
        if value == nil {
            
            value = NSNull() as? Value
        }
        
        if let value: Value = aValue {
            
            self[aKey] = value
        }
    }
}
