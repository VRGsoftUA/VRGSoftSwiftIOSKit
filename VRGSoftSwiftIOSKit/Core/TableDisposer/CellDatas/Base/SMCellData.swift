//
//  SMCellData.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMCellData
{
    var cellSelectedHandlers: [SMBlockAction<SMCellData>] = []
    var cellDeselectedHandlers: [SMBlockAction<SMCellData>] = []
    
    var cellNibName: String?
    var cellClass: UITableViewCell.Type = UITableViewCell.self
    var cellIdentifier: String
    {
        get {return String(describing: type(of: self))}
    }
    
    var cellStyle: UITableViewCellStyle! = UITableViewCellStyle.default

    var cellSelectionStyle: UITableViewCellSelectionStyle! = UITableViewCellSelectionStyle.default
    var cellAccessoryType: UITableViewCellAccessoryType! = UITableViewCellAccessoryType.none
    
    var isAutoDeselect: Bool = true
    var isVisible: Bool = true
    var isEnableEdit: Bool = true
    var isDisableInputTraits: Bool = false
    var tag: Int = 0
    var userData: [String: Any] = [:]
    
    var isCellHeightAutomaticDimension = false
    
    var cellHeight: CGFloat = 44.0
    var cellWidth: CGFloat = 0.0

    func cellHeightFor(width aWidth: CGFloat) -> CGFloat
    {
        return self.cellHeight
    }
    
    
    // MARK: Handlers
    
    func addCellSelected(blockAction aBlockAction:SMBlockAction<SMCellData>) -> Void
    {
        cellSelectedHandlers.append(aBlockAction)
    }
    
    func addCellDeselected(blockAction aBlockAction:SMBlockAction<SMCellData>) -> Void
    {
        cellDeselectedHandlers.append(aBlockAction)
    }

    func performSelectedHandlers() -> Void
    {
        for handler in cellSelectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }

    func performDeselectedHandlers() -> Void
    {
        for handler in cellDeselectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }


    // MARK: Create cell
    
    func createCell() -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        if let cellNibName = cellNibName
        {
            cell = (Bundle.main.loadNibNamed(cellNibName, owner: self, options: nil)?.last! as! SMCell)
        }
        else
        {
            cell = cellClass.init(style: self.cellStyle, reuseIdentifier: self.cellIdentifier)
        }
        
        return cell!
    }}
