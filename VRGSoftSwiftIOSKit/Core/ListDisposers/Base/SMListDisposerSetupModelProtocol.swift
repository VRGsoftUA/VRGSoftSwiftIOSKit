//
//  SMListDisposerSetupModelProtocol.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/19.
//  Copyright © 2019 OLEKSANDR SEMENIUK. All rights reserved.
//

//SMListDisposerModeledCreateCellDataDelegate

public protocol SMListDisposerSetupModelProtocol: class {
    
    var modeledMulticastDelegate: SMMulticastDelegate<SMListDisposerModeledCreateCellDataDelegate> { get }
    var modeledDelegate: SMListDisposerModeledDelegate? { get set }

    func didCreate(cellData aCellData: SMListCellData)
    func cellDataFrom(model aModel: AnyObject) -> SMListCellData?

    func register(cellDataClass aCellDataClass: SMListCellData.Type, forModelClass aModelClass: AnyClass?)
    func unregisterCellDataFor(modelClass aModelClass: AnyClass)
    
    func setupModels(_ aModels: [AnyObject], forSectionAtIndex aSectionIndex: Int)
    func setupModels(_ aModels: [AnyObject], forSection aSection: SMListSection)
}
