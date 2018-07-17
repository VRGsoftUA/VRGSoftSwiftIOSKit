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
    var cellSelectedHandlers: [SMBlockAction<SMCellData>] = []
    var cellDeselectedHandlers: [SMBlockAction<SMCellData>] = []
    
    var cellNibName: String?
    var cellClass: UITableViewCell.Type = UITableViewCell.self
    var cellIdentifier: String
    {
        return String(describing: type(of: self))
    }
    
    var cellStyle: UITableViewCellStyle = UITableViewCellStyle.default

    var cellSelectionStyle: UITableViewCellSelectionStyle = UITableViewCellSelectionStyle.default
    var cellAccessoryType: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
    var cellSeparatorInset: UIEdgeInsets?
    
    var isAutoDeselect: Bool = true
    var isEnableEdit: Bool = true
    var isDisableInputTraits: Bool = false
    
    var isCellHeightAutomaticDimension = false
    
    var cellHeight: CGFloat = 44.0
    var cellWidth: CGFloat = 0.0

    func cellHeightFor(width aWidth: CGFloat) -> CGFloat
    {
        return cellHeight
    }
    
    
    // MARK: Handlers
    
    func addCellSelected(blockAction aBlockAction: SMBlockAction<SMCellData>)
    {
        cellSelectedHandlers.append(aBlockAction)
    }
    
    func addCellDeselected(blockAction aBlockAction: SMBlockAction<SMCellData>)
    {
        cellDeselectedHandlers.append(aBlockAction)
    }

    func performSelectedHandlers()
    {
        for handler in cellSelectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }

    func performDeselectedHandlers()
    {
        for handler in cellDeselectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }


    // MARK: Create cell
    
    func createCell() -> UITableViewCell
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
