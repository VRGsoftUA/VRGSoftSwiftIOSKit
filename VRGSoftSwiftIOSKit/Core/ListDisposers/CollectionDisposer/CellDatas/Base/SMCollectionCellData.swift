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
    var cellNibName: String?
    var cellClass: UICollectionViewCell.Type = UICollectionViewCell.self
    var cellIdentifier: String
    {
        return String(describing: type(of: self))
    }
    
    class var cellClass_: UICollectionViewCell.Type
    {
        return UICollectionViewCell.self
    }
    
    class var cellNibName_: String?
    {
        return nil
    }
    
    class var cellIdentifier_: String
    {
        return String(describing: self)
    }
    
    var isAutoDeselect: Bool = true

    var cellSize: CGSize?

    func cellSizeFor(size aSize: CGSize) -> CGSize?
    {
        return cellSize
    }
}
