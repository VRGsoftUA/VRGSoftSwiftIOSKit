//
//  SMCellData.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMCellData: SMListCellData
{
    open var cellSelectedHandlers: [SMBlockAction<SMCellData>] = []
    open var cellDeselectedHandlers: [SMBlockAction<SMCellData>] = []
    
    open var cellNibName: String?
    open var cellClass: UITableViewCell.Type = UITableViewCell.self
    
    open var cellStyle: UITableViewCell.CellStyle = UITableViewCell.CellStyle.default

    open var cellSelectionStyle: UITableViewCell.SelectionStyle = UITableViewCell.SelectionStyle.default
    open var cellAccessoryType: UITableViewCell.AccessoryType = UITableViewCell.AccessoryType.none
    open var cellSeparatorInset: UIEdgeInsets?
    
    open var isAutoDeselect: Bool = true
    open var isEnableEdit: Bool = true
    open var isDisableInputTraits: Bool = false
    
    open var isCellHeightAutomaticDimension: Bool = false
    
    open var cellHeight: CGFloat = 44.0
    open var cellWidth: CGFloat = 0.0

    open func cellHeightFor(width aWidth: CGFloat) -> CGFloat
    {
        return cellHeight
    }
    
    
    // MARK: Handlers
    
    open func addCellSelected(blockAction aBlockAction: SMBlockAction<SMCellData>)
    {
        cellSelectedHandlers.append(aBlockAction)
    }
    
    open func addCellDeselected(blockAction aBlockAction: SMBlockAction<SMCellData>)
    {
        cellDeselectedHandlers.append(aBlockAction)
    }

    open func performSelectedHandlers()
    {
        for handler: SMBlockAction<SMCellData> in cellSelectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }

    open func performDeselectedHandlers()
    {
        for handler: SMBlockAction<SMCellData> in cellDeselectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }


    // MARK: Create cell
    
    open func createCell() -> UITableViewCell
    {
        if let cellNibName: String = cellNibName
        {
            let cell: UITableViewCell = Bundle.main.loadNibNamed(cellNibName, owner: nil, options: nil)?.last as! UITableViewCell // swiftlint:disable:this force_cast
            return cell
        } else
        {
            let cell: UITableViewCell = cellClass.init(style: cellStyle, reuseIdentifier: cellIdentifier)
            return cell
        }
    }}
