//
//  SMCollectionDisposerModeled.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public protocol SMCollectionDisposerModeledMulticastDelegate: class
{
    func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, didCreateCellData aCellData: SMCollectionCellData)
}


public protocol SMCollectionDisposerModeledDelegate: class
{
    func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, didCreateCellData aCellData: SMCollectionCellData)
    func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> SMCollectionCellData.Type?
}


open class SMCollectionDisposerModeled: SMCollectionDisposer
{
    open let modeledMulticastDelegate: SMMulticastDelegate<SMCollectionDisposerModeledMulticastDelegate> = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory) // swiftlint:disable:this weak_delegate
    
    open var registeredClasses: [String: SMCollectionCellData.Type] = [:]
    
    open weak var modeledDelegate: SMCollectionDisposerModeledDelegate?
    
    open func register(cellDataClass aCellDataClass: SMCollectionCellData.Type, forModelClass aModelClass: AnyClass? = nil)
    {
        if let nibName: String = aCellDataClass.cellNibName_
        {
            collectionView?.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: aCellDataClass.cellIdentifier_)
        } else
        {
            collectionView?.register(aCellDataClass.cellClass_, forCellWithReuseIdentifier: aCellDataClass.cellIdentifier_)
        }
        if let aModelClass: AnyClass = aModelClass
        {
            registeredClasses[String(describing: aModelClass)] = aCellDataClass
        }
    }

    open func unregisterCellDataFor(modelClass aModelClass: AnyClass)
    {
        registeredClasses[String(describing: aModelClass)] = nil
    }
    
    open func setupModels(_ aModels: [AnyObject], forSectionAtIndex aSectionIndex: Int)
    {
        let section: SMCollectonSection = sections[aSectionIndex]
        setupModels(aModels, forSection: section)
    }
    
    open func setupModels(_ aModels: [AnyObject], forSection aSection: SMCollectonSection)
    {
        for model: AnyObject in aModels
        {
            if let cellData: SMCollectionCellData = cellDataFrom(model: model)
            {
                aSection.addCellData(cellData)
                didCreate(cellData: cellData)
            } else
            {
                assert(false, String(format: "Model doesn't have registered cellData class %@", String(describing: type(of: model))))
            }
        }
    }
    
    open func cellDataFrom(model aModel: AnyObject) -> SMCollectionCellData?
    {
        let modelClassName: String = String(describing: type(of: aModel))
        
        if let cellDataClass: SMCollectionCellData.Type = registeredClasses[modelClassName] ?? modeledDelegate?.collectionDisposer(self, cellDataClassForUnregisteredModel: aModel)
        {
            let cellData: SMCollectionCellData = cellDataClass.init(model: aModel)
            
            return cellData
        }
        
        return nil
    }
    
    open func didCreate(cellData aCellData: SMCollectionCellData)
    {
        modeledDelegate?.collectionDisposer(self, didCreateCellData: aCellData)
        modeledMulticastDelegate.invokeDelegates { [weak self] delegate in
            if let strongSelf: SMCollectionDisposerModeled = self
            {
                delegate.collectionDisposer(strongSelf, didCreateCellData: aCellData)
            }
        }
    }
}


public extension SMCollectionDisposerModeledMulticastDelegate
{
    public func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, didCreateCellData aCellData: SMCollectionCellData)
    {
        
    }
}

public extension SMCollectionDisposerModeledDelegate
{
    public func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, didCreateCellData aCellData: SMCollectionCellData)
    {
        
    }
    
    public func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> SMCollectionCellData.Type?
    {
        assert(false)
        return nil
    }
}
