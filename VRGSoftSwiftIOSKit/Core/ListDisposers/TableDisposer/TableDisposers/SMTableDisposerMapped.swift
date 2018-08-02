//
//  SMTableDisposerMapped.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 6/23/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import UIKit

open class SMTableDisposerMapped: SMTableDisposer
{
    open func mapFromObject()
    {
        for section: SMSectionReadonly in sections
        {
            if let section: SMSectionWritable = section as? SMSectionWritable
            {
                section.mapFromObject()
            }
        }
    }

    open func mapToObject()
    {
        for section: SMSectionReadonly in sections
        {
            if let section: SMSectionWritable = section as? SMSectionWritable
            {
                section.mapToObject()
            }
        }
    }

    override open func reloadData()
    {
        (tableView as? SMKeyboardAvoidingTableView)?.removeAllObjectsForKeyboard()
        
        mapFromObject()
        
        for section: SMSectionReadonly in sections
        {
            section.updateCellDataVisibility()
        }
        
        tableView?.reloadData()
    }
}
