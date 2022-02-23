//
//  SMListDisposerModeledDelegate.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

public protocol SMListDisposerModeledCreateCellDataDelegate: AnyObject {
    
    func listDisposer(_ aListDisposer: SMListDisposer, didCreateCellData aCellData: SMListCellData)
}


public protocol SMListDisposerModeledDelegate: SMListDisposerModeledCreateCellDataDelegate {
    
    func listDisposer(_ aListDisposer: SMListDisposer, cellDataClassForUnregisteredModel aModel: Any) -> SMListCellData.Type
}


public extension SMListDisposerModeledCreateCellDataDelegate {
    
    func listDisposer(_ aListDisposer: SMListDisposer, didCreateCellData aCellData: SMListCellData) { }
}
