//
//  SMCellDataMaped.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMCellDataMaped: SMCellData, SMCellDataMapedProtocol {
    
    open var key: String?
    
    public convenience init(model aModel: AnyObject?, key aKey: String?) {
        
        self.init(model: aModel)
        
        key = aKey
    }
    
    
    // MARK: SMCellDataMapedProtocol
    
    open func mapFromObject() {
        
        assert(false, "Override this method in subclasses!")
    }

    open func mapToObject() {
        
        assert(false, "Override this method in subclasses!")
    }
}
