//
//  SMBOReloadProtocol.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/3/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import CoreData

public protocol SMBOReloadProtocol {
    func reloadNotificationKey() -> String
    func sendDidReloadNotification()
}

public extension SMBOReloadProtocol where Self: SMDBStorableObject {
    
    func reloadNotificationKey() -> String {
        
        let description: String = String(describing: type(of: self))
        let result: String = "SMBOReloadProtocol" + "\(description)" + "\(_identifier ?? "")"
        
        return result
    }
    
    func sendDidReloadNotification() {
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.reloadNotificationKey()), object: self)
        }
    }
}
