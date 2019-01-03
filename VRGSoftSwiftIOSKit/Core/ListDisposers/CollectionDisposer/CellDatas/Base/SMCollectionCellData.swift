//
//  SMCollectionCellData.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMCollectionCellData: SMListCellData
{
    open var cellNibName: String?
    open var cellClass: UICollectionViewCell.Type = UICollectionViewCell.self
    override open var cellIdentifier: String
    {
        let result: String = type(of: self).cellIdentifier_
        return result
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
        let result: String = String(describing: self)
        return result
    }
    
    open var isAutoDeselect: Bool = true
    
    open var cellSize: CGSize?
    
    open func cellSizeFor(size aSize: CGSize) -> CGSize?
    {
        return cellSize
    }
}
