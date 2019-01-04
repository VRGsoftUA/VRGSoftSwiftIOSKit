//
//  SMListDisposerModeledDelegate.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/19.
//  Copyright © 2019 OLEKSANDR SEMENIUK. All rights reserved.
//

public protocol SMListDisposerModeledCreateCellDataDelegate: class
{
    func listDisposer(_ aListDisposer: SMListDisposer, didCreateCellData aCellData: SMListCellData)
}


public protocol SMListDisposerModeledDelegate: SMListDisposerModeledCreateCellDataDelegate
{
    func listDisposer(_ aListDisposer: SMListDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> SMListCellData.Type
}


public extension SMListDisposerModeledCreateCellDataDelegate
{
    func listDisposer(_ aListDisposer: SMListDisposer, didCreateCellData aCellData: SMListCellData)
    {
        
    }
}
