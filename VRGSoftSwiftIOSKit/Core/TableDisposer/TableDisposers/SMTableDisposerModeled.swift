//
//  SMTableDisposerModeled.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public protocol SMTableDisposerModeledMulticastDelegate: class
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellDataModeled) -> Void
}

public protocol SMTableDisposerModeledDelegate: class
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellDataModeled) -> Void
    func tableDisposer(_ aTableDisposer: SMTableDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> SMCellDataModeled.Type
}

open class SMTableDisposerModeled: SMTableDisposer
{
    let modeledMulticastDelegate: SMMulticastDelegate<SMTableDisposerModeledMulticastDelegate> = SMMulticastDelegate(strongReferences: false)

    var registeredClasses : [String: SMCellDataModeled.Type] = [:]
    
    weak var modeledDelegate: SMTableDisposerModeledDelegate?
    
    func register(cellDataClass aCellDataClass: SMCellDataModeled.Type, forModelClass aModelClass: AnyClass) -> Void
    {
        registeredClasses[String(describing: aModelClass)] = aCellDataClass
    }

    func unregisterCellDataFor(modelClass aModelClass: AnyClass) -> Void
    {
        registeredClasses[String(describing: aModelClass)] = nil
    }

    func setupModels(_ aModels: [AnyObject], forSectionAtIndex aSectionIndex: Int) -> Void
    {
        let section: SMSectionReadonly = self.sections[aSectionIndex]
        self.setupModels(aModels, forSection: section)
    }

    func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly) -> Void
    {
        for model in aModels
        {
            let cellData: SMCellDataModeled = self.cellDataFrom(model: model)
            aSection.addCellData(cellData)
            self.didCreate(cellData: cellData)
        }
    }

    func cellDataFrom(model aModel: AnyObject) -> SMCellDataModeled
    {
        let modelClassName: String = String(describing: type(of: aModel))

        var cellDataClass: SMCellDataModeled.Type? = registeredClasses[modelClassName]

        if cellDataClass == nil
        {
            cellDataClass = modeledDelegate?.tableDisposer(self, cellDataClassForUnregisteredModel: aModel)
        }
        
        assert(cellDataClass != nil, String(format: "Model doesn't have registered cellData class %@", modelClassName))
        
        let cellData: SMCellDataModeled = cellDataClass!.init(model: aModel)
        
        return cellData
    }

    func didCreate(cellData aCellData: SMCellDataModeled) -> Void
    {
        self.modeledDelegate?.tableDisposer(self, didCreateCellData: aCellData)
        self.modeledMulticastDelegate.invokeDelegates { (delegate) in
            delegate.tableDisposer(self, didCreateCellData: aCellData)
        }
    }
}


extension SMTableDisposerModeledMulticastDelegate
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellDataModeled) -> Void
    {
        
    }
}

extension SMTableDisposerModeledDelegate
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellDataModeled) -> Void
    {
        
    }
    
    func tableDisposer(_ aTableDisposer: SMTableDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> SMCellDataModeled.Type?
    {
        assert(false)
        return nil
    }
}
