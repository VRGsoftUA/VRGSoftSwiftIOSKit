//
//  SMListCellData.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

public typealias SMListCellDataDidSelectClosureType = (_ cellData: SMListCellData) -> Void

open class SMListCellData
{
    open let model: AnyObject?
    
    open var didSelectClosure: SMListCellDataDidSelectClosureType?
    
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
