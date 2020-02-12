//
//  SMPair.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation

open class SMPair <FirstType, SecondType> {
    
    open var first: FirstType?
    open var second: SecondType?
    
    public init(first aFirst: FirstType?, second aSecond: SecondType?) {
        
        first = aFirst
        second = aSecond
    }
    
    open func copy() -> Any {
        
        return SMPair(first: first, second: second)
    }
    
    open var description: String {
        
        return "\(String(describing: first)) \(String(describing: second))"
    }
}
