//
//  Sequence+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/27/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

extension Sequence where Element == () -> Void {
    
    func callAll() {
        
        self.forEach { $0() }
    }
}
