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
        self.backgroundColor = UIColor.clear
    }
    
    required public init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    
    func inputTraits() -> [UIResponder]?
    {
        return nil
    }
    
    override open var reuseIdentifier: String
    {
        get { return self.cellData!.cellIdentifier }
    }

    override open func awakeFromNib()
    {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: SMCellProtocol
    
    open var cellData: SMCellData? = nil
    open func setupCellData(_ aCellData: SMCellData!) -> Void
    {
        cellData = aCellData

        self.selectionStyle = aCellData.cellSelectionStyle
        self.accessoryType = aCellData.cellAccessoryType

        self.tag = aCellData.tag
    }
}
