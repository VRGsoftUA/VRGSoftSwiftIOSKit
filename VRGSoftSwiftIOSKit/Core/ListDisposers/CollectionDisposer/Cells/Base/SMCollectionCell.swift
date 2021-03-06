//
//  SMCollectionCell.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMCollectionCell: UICollectionViewCell, SMCellProtocol {
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    open func setup() {
        
        backgroundColor = UIColor.clear
    }
    
    open func inputTraits() -> [UIResponder]? {
        
        return nil
    }
    
    
    // MARK: SMCollectionCellProtocol
    
    open var cellData: SMListCellData?
    
    open func setupCellData(_ aCellData: SMListCellData) {
        
        cellData = aCellData
        
        tag = aCellData.tag
    }
}
