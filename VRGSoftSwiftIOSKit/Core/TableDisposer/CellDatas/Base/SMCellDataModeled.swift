//
//  SMCellDataModeled.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMCellDataModeled: SMCellData
{
    let model : AnyObject
        
    required init(model aModel: AnyObject)
    {
        model = aModel
        super.init()
    }
}
