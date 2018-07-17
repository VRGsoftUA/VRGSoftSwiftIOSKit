//
//  SMCollectionCellData.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import UIKit

open class SMCollectionCellData: SMListCellData
{
    open var cellNibName: String?
    open var cellClass: UICollectionViewCell.Type = UICollectionViewCell.self
    open var cellIdentifier: String
    {
        return String(describing: type(of: self))
    }
    
    open class var cellClass_: UICollectionViewCell.Type
    {
        return UICollectionViewCell.self
    }
    
    open class var cellNibName_: String?
    {
        return nil
    }
    
    open class var cellIdentifier_: String
    {
        return String(describing: self)
    }
    
    open var isAutoDeselect: Bool = true

    open var cellSize: CGSize?

    open func cellSizeFor(size aSize: CGSize) -> CGSize?
    {
        return cellSize
    }
}
