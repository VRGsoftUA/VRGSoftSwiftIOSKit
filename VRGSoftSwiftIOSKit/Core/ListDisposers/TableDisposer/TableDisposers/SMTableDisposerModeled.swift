//
//  SMTableDisposerModeled.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMTableDisposerModeled: SMTableDisposer, SMListDisposerSetupModelProtocol {
    
    public override init() {
        
        modeledMulticastDelegate = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory)

        super.init()
    }
    
    // MARK: SMListDisposerSetupModelProtocol
    
    open var modeledMulticastDelegate: SMMulticastDelegate<SMListDisposerModeledCreateCellDataDelegate>// = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory) // swiftlint:disable:this weak_delegate

    open var registeredClasses: [String: SMListCellData.Type] = [:]
    
    open weak var modeledDelegate: SMListDisposerModeledDelegate?
    
    open func register(cellDataClass aCellDataClass: SMListCellData.Type, forModelClass aModelClass: AnyClass?) {
        
        if let aModelClass: AnyClass = aModelClass {
            
            registeredClasses[String(describing: aModelClass)] = aCellDataClass
        }
    }

    open func unregisterCellDataFor(modelClass aModelClass: AnyClass) {
        
        registeredClasses[String(describing: aModelClass)] = nil
    }

    open func setupModels(_ aModels: [AnyObject], forSectionAtIndex aSectionIndex: Int) {
        
        let section: SMListSection = sections[aSectionIndex]
        setupModels(aModels, forSection: section)
    }

    open func setupModels(_ aModels: [AnyObject], forSection aSection: SMListSection) {
        
        for model: AnyObject in aModels {
            
            if let cellData: SMListCellData = cellDataFrom(model: model) {
                
                didCreate(cellData: cellData)
                aSection.addCellData(cellData)
            } else {
                
                assert(false, String(format: "Model doesn't have registered cellData class %@", String(describing: type(of: model))))
            }
        }
    }

    open func cellDataFrom(model aModel: AnyObject) -> SMListCellData? {
        
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
            
            if let strongSelf: SMTableDisposerModeled = self {
                
                delegate.listDisposer(strongSelf, didCreateCellData: aCellData)
            }
        }
    }
}
