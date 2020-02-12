//
//  SMListCellData.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMListCellData {
    
    public let model: AnyObject?
        
    open var baSelect: SMBlockAction<SMListCellData>?
    open var isVisible: Bool = true
    open var tag: Int = 0
    open var userData: [String: Any] = [:]
    
    open var cellIdentifier: String {
        
        return String(describing: type(of: self))
    }
    
    public convenience init() {
        
        self.init(model: nil)
    }
    
    public required init(model aModel: AnyObject?) {
        
        model = aModel
    }
}
