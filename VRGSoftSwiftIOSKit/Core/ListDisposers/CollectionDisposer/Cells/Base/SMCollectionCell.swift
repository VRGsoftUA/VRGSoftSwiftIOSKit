//
//  SMCollectionCell.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import UIKit

open class SMCollectionCell: UICollectionViewCell, SMCollectionCellProtocol
{
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
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
    
    
    // MARK: SMCollectionCellProtocol
    
    public var cellData: SMCollectionCellData?
    
    public func setupCellData(_ aCellData: SMCollectionCellData)
    {
        cellData = aCellData
        
        tag = aCellData.tag
    }
}
