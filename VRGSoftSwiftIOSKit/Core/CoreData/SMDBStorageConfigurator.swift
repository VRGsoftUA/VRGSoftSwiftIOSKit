//
//  SMDBStorageConfigurator.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import Foundation

open class SMDBStorageConfigurator {
    
    public static var storageType: SMDBStorage.Type?
    public static var storage: SMDBStorage? = SMDBStorageConfigurator.storageType?.init()
    
    public static func registerStorageClass(_ storageType: SMDBStorage.Type) {
        
        self.storageType = storageType
        storage = storageType.init()
    }
}
