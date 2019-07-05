//
//  Optional+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/27/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

extension Optional where Wrapped: Collection {
    
    var isNilOrEmpty: Bool {
        
        return self.flatMap { $0.isEmpty } ?? true
    }
    
    var hasElements: Bool {
        
        return !self.isNilOrEmpty
    }
}
