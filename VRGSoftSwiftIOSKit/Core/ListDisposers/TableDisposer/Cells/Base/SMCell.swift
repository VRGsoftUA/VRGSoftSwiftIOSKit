//
//  SMCell.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMCell: UITableViewCell, SMCellProtocol {
    
    required override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    open func setup() {
        
        backgroundColor = UIColor.clear
    }
    
    open func inputTraits() -> [UIResponder]? {
        
        return nil
    }
    
    override open var reuseIdentifier: String? {
        
        return (cellData as? SMCellData)?.cellIdentifier
    }

    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
    
    
    // MARK: SMCellProtocol
    
    open var cellData: SMListCellData?
    open func setupCellData(_ aCellData: SMListCellData) {
        
        cellData = aCellData

        if let cellData: SMCellData = aCellData as? SMCellData {
            
            selectionStyle = cellData.cellSelectionStyle
            accessoryType = cellData.cellAccessoryType
            
            if let inset: UIEdgeInsets = cellData.cellSeparatorInset {
                
                separatorInset = inset
            }
        }
        
        tag = aCellData.tag
    }
}
