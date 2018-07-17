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
    open var cellIdentifier: String
    {
        return String(describing: type(of: self))
    }
    
    open var cellStyle: UITableViewCellStyle = UITableViewCellStyle.default

    open var cellSelectionStyle: UITableViewCellSelectionStyle = UITableViewCellSelectionStyle.default
    open var cellAccessoryType: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
    open var cellSeparatorInset: UIEdgeInsets?
    
    open var isAutoDeselect: Bool = true
    open var isEnableEdit: Bool = true
    open var isDisableInputTraits: Bool = false
    
    open var isCellHeightAutomaticDimension = false
    
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
        for handler in cellSelectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }

    open func performDeselectedHandlers()
    {
        for handler in cellDeselectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }


    // MARK: Create cell
    
    open func createCell() -> UITableViewCell
    {
        if let cellNibName = cellNibName
        {
            let cell = Bundle.main.loadNibNamed(cellNibName, owner: nil, options: nil)?.last as! UITableViewCell // swiftlint:disable:this force_cast
            return cell
        } else
        {
            let cell = cellClass.init(style: cellStyle, reuseIdentifier: cellIdentifier)
            return cell
        }
    }}