//
//  SMCell.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMCell: UITableViewCell, SMCellProtocol
{    
    required override public init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup()
    {
        backgroundColor = UIColor.clear
    }
    
    func inputTraits() -> [UIResponder]?
    {
        return nil
    }
    
    override open var reuseIdentifier: String?
    {
        return cellData?.cellIdentifier
    }

    override open func awakeFromNib()
    {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    
    // MARK: SMCellProtocol
    
    open var cellData: SMCellData?
    open func setupCellData(_ aCellData: SMCellData)
    {
        cellData = aCellData

        selectionStyle = aCellData.cellSelectionStyle
        accessoryType = aCellData.cellAccessoryType
        
        if let inset = aCellData.cellSeparatorInset
        {
            separatorInset = inset
        }
        
        tag = aCellData.tag
    }
}
