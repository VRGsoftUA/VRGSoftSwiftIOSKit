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
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellData)
}

public protocol SMTableDisposerModeledDelegate: class
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellData)
    func tableDisposer(_ aTableDisposer: SMTableDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> SMCellData.Type
}

open class SMTableDisposerModeled: SMTableDisposer
{
    public let modeledMulticastDelegate: SMMulticastDelegate<SMTableDisposerModeledMulticastDelegate> = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory) // swiftlint:disable:this weak_delegate

    open var registeredClasses: [String: SMCellData.Type] = [:]
    
    open weak var modeledDelegate: SMTableDisposerModeledDelegate?
    
    open func register(cellDataClass aCellDataClass: SMCellData.Type, forModelClass aModelClass: AnyClass)
    {
        registeredClasses[String(describing: aModelClass)] = aCellDataClass
    }

    open func unregisterCellDataFor(modelClass aModelClass: AnyClass)
    {
        registeredClasses[String(describing: aModelClass)] = nil
    }

    open func setupModels(_ aModels: [AnyObject], forSectionAtIndex aSectionIndex: Int)
    {
        let section: SMSectionReadonly = sections[aSectionIndex]
        setupModels(aModels, forSection: section)
    }

    open func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly)
    {
        for model: AnyObject in aModels
        {
            if let cellData: SMCellData = cellDataFrom(model: model)
            {
                aSection.addCellData(cellData)
                didCreate(cellData: cellData)
            } else
            {
                assert(false, String(format: "Model doesn't have registered cellData class %@", String(describing: type(of: model))))
            }
        }
    }

    open func cellDataFrom(model aModel: AnyObject) -> SMCellData?
    {
        let modelClassName: String = String(describing: type(of: aModel))

        if let cellDataClass: SMCellData.Type = registeredClasses[modelClassName] ?? modeledDelegate?.tableDisposer(self, cellDataClassForUnregisteredModel: aModel)
        {
            let cellData: SMCellData = cellDataClass.init(model: aModel)
            return cellData
        }
        
        return nil
    }

    open func didCreate(cellData aCellData: SMCellData)
    {
        modeledDelegate?.tableDisposer(self, didCreateCellData: aCellData)
        modeledMulticastDelegate.invokeDelegates { [weak self] delegate in // swiftlint:disable:this explicit_type_interface
            if let strongSelf: SMTableDisposerModeled = self
            {
                delegate.tableDisposer(strongSelf, didCreateCellData: aCellData)
            }
        }
    }
}


public extension SMTableDisposerModeledMulticastDelegate
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellData)
    {
        
    }
}

public extension SMTableDisposerModeledDelegate
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellData)
    {
        
    }
}
