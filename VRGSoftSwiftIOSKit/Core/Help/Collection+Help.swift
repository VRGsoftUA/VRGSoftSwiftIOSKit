//
//  Collection+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/27/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

public extension Collection {
    
    subscript(safe index: Index) -> Element? {
        
        let result: Element? = self.indices.contains(index) ? self[index] : nil
        
        return result
    }
}

public extension Collection where Element: Numeric {
    
    func sum() -> Element {
        
        let result: Element = self.reduce(0, +)
        
        return result
    }
}
