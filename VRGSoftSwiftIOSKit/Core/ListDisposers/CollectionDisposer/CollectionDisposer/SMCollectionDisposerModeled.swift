//
//  SMCollectionDisposerModeled.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit


open class SMCollectionDisposerModeled: SMCollectionDisposer, SMListDisposerSetupModelProtocol {
    
    public override init() {
        
        modeledMulticastDelegate = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory)
        
        super.init()
    }
    
    
    // MARK: SMListDisposerSetupModelProtocol
    
    open var modeledMulticastDelegate: SMMulticastDelegate<SMListDisposerModeledCreateCellDataDelegate>// = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory) // swiftlint:disable:this weak_delegate

    open var registeredClasses: [String: SMListCellData.Type] = [:]
    
    open weak var modeledDelegate: SMListDisposerModeledDelegate?

    open func register(cellDataClass aCellDataClass: SMListCellData.Type, forModelClass aModelClass: Any? = nil) {
        
        if let cellDataClass: SMCollectionCellData.Type = aCellDataClass as? SMCollectionCellData.Type {
            
            if let nibName: String = cellDataClass.cellNibName_ {
                
                collectionView?.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: cellDataClass.cellIdentifier_)
            } else {
                
                collectionView?.register(cellDataClass.cellClass_, forCellWithReuseIdentifier: cellDataClass.cellIdentifier_)
            }
            
            if let aModelClass: Any = aModelClass {
                
                registeredClasses[String(describing: aModelClass)] = cellDataClass
            }
        }
    }

    open func unregisterCellDataFor(modelClass aModelClass: Any) {
        
        registeredClasses[String(describing: aModelClass)] = nil
    }
    
    open func setupModels(_ aModels: [Any], forSectionAtIndex aSectionIndex: Int) {
        
        let section: SMListSection = sections[aSectionIndex]
        setupModels(aModels, forSection: section)
    }
    
    open func setupModels(_ aModels: [Any], forSection aSection: SMListSection) {
        
        for model: Any in aModels {
            
            if let cellData: SMListCellData = cellDataFrom(model: model) {
                
                didCreate(cellData: cellData)
                aSection.addCellData(cellData)
            } else {
                
                assert(false, String(format: "Model doesn't have registered cellData class %@", String(describing: type(of: model))))
            }
        }
    }
    
    open func cellDataFrom(model aModel: Any) -> SMListCellData? {
        
        let modelClassName: String = String(describing: type(of: aModel))
        
        if let cellDataClass: SMListCellData.Type = registeredClasses[modelClassName] ?? modeledDelegate?.listDisposer(self, cellDataClassForUnregisteredModel: aModel) {
            
            let cellData: SMListCellData = cellDataClass.init(model: aModel)
            
            return cellData
        }
        
        return nil
    }
    
    open func didCreate(cellData aCellData: SMListCellData) {
        
        modeledDelegate?.listDisposer(self, didCreateCellData: aCellData)
        modeledMulticastDelegate.invokeDelegates { [weak self] delegate in
            
            if let strongSelf: SMCollectionDisposerModeled = self {
                
                delegate.listDisposer(strongSelf, didCreateCellData: aCellData)
            }
        }
    }
}
