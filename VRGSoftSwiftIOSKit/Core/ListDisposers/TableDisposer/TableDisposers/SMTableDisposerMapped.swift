//
//  SMTableDisposerMapped.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/23/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMTableDisposerMapped: SMTableDisposer {
    
    open func mapFromObject() {
        
        for section: SMListSection in sections {
            
            if let section: SMSectionWritable = section as? SMSectionWritable {
                
                section.mapFromObject()
            }
        }
    }

    open func mapToObject() {
        
        for section: SMListSection in sections {
            
            if let section: SMSectionWritable = section as? SMSectionWritable {
                
                section.mapToObject()
            }
        }
    }

    override open func reloadData() {
        
        (tableView as? SMKeyboardAvoidingTableView)?.removeAllObjectsForKeyboard()
        
        mapFromObject()
        
        for section: SMListSection in sections {
            
            section.updateCellDataVisibility()
        }
        
        tableView?.reloadData()
    }
}
