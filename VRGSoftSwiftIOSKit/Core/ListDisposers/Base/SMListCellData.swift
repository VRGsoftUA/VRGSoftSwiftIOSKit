//
//  SMListCellData.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

typealias SMListCellDataDidSelectClosureType = (_ cellData: SMListCellData) -> Void

open class SMListCellData
{
    let model: AnyObject?
    
    var didSelectClosure: SMListCellDataDidSelectClosureType?
    
    var isVisible: Bool = true
    var tag: Int = 0
    var userData: [String: Any] = [:]
    
    public convenience init()
    {
        self.init(model: nil)
    }
    
    public required init(model aModel: AnyObject?)
    {
        model = aModel
    }
}
