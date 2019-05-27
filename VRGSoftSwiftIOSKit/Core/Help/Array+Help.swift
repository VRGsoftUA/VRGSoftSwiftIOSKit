//
//  Array+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/27/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

extension Array {
    
    @discardableResult
    mutating func safeRemoveElement(atIndex index: Index) -> Element? {
        
        var result: Element?
        
        if self.indices.contains(index) {
            
            result = remove(at: index)
        }
        
        return result
    }
    
    mutating func safeSetElement(_ element: Element, atIndex index: Index) {
        
        if self.indices.contains(index) {
            
            self[index] = element
        }
    }
}

extension Array where Element: Equatable {
    
    @discardableResult
    mutating func safeRemoveElement(_ element: Element) -> Element? {
        
        var result: Element?
        
        if let index: Index = self.firstIndex(of: element) {
            
            result = remove(at: index)
        }
        
        return result
    }
}
