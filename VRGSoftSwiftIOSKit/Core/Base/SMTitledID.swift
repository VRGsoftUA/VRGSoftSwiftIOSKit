//
//  SMTitledID.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation

open class SMTitledID {
    
    open var ID: AnyObject
    open var title: String

    public init(ID aID: AnyObject, title aTitle: String) {
        
        ID = aID
        title = aTitle
    }

    open func copy() -> SMTitledID {
        
        let theCopy: SMTitledID = SMTitledID(ID: ID, title: title)
        return theCopy
    }
    
    open var description: String {
        return "\(String(describing: ID)) \(String(describing: title))"
    }
}

extension SMTitledID: Equatable {
    
    public static func == (lhs: SMTitledID, rhs: SMTitledID) -> Bool {
        return lhs.ID === rhs.ID && lhs.title == rhs.title
    }
}
