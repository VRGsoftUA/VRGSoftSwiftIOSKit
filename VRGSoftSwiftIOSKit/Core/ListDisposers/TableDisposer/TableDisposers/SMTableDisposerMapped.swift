//
//  SMTableDisposerMapped.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 6/23/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import UIKit

class SMTableDisposerMapped: SMTableDisposer
{
    func mapFromObject()
    {
        for section: SMSectionReadonly in sections
        {
            if let section = section as? SMSectionWritable
            {
                section.mapFromObject()
            }
        }
    }

    func mapToObject()
    {
        for section: SMSectionReadonly in sections
        {
            if let section = section as? SMSectionWritable
            {
                section.mapToObject()
            }
        }
    }

    override func reloadData()
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
