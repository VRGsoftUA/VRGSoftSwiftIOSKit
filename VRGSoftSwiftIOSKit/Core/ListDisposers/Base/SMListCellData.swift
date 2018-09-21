//
//  SMListCellData.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

@available(*, deprecated)
public typealias SMListCellDataDidSelectClosureType = (_ cellData: SMListCellData) -> Void

open class SMListCellData
{
    public let model: AnyObject?
    
    @available(*, deprecated)
    open var didSelectClosure: SMListCellDataDidSelectClosureType?
    
    open var baSelect: SMBlockAction<SMListCellData>?
    open var isVisible: Bool = true
    open var tag: Int = 0
    open var userData: [String: Any] = [:]
    
    public convenience init()
    {
        self.init(model: nil)
    }
    
    public required init(model aModel: AnyObject?)
    {
        model = aModel
    }
}
