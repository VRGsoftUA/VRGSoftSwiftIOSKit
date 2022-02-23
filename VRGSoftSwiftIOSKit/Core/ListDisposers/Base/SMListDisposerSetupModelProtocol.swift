//
//  SMListDisposerSetupModelProtocol.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

// SMListDisposerModeledCreateCellDataDelegate

public protocol SMListDisposerSetupModelProtocol where Self: SMListDisposer {
    
    var modeledMulticastDelegate: SMMulticastDelegate<SMListDisposerModeledCreateCellDataDelegate> { get }
    var modeledDelegate: SMListDisposerModeledDelegate? { get set }

    func didCreate(cellData aCellData: SMListCellData)
    func cellDataFrom(model aModel: Any) -> SMListCellData?

    func register(cellDataClass aCellDataClass: SMListCellData.Type, forModelClass aModelClass: Any?)
    func unregisterCellDataFor(modelClass aModelClass: Any)
    
    func setupModels(_ aModels: [Any], forSectionAtIndex aSectionIndex: Int)
    func setupModels(_ aModels: [Any], forSection aSection: SMListSection)
}
