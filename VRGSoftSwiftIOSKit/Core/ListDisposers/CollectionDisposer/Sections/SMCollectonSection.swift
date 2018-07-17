//
//  SMCollectonSection.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import UIKit

public typealias SMCollectonSectionSetupViewBlock = (UICollectionReusableView) -> Void

open class SMCollectonSection: SMListSection<SMCollectionCellData>
{
    open weak var collectionDisposer: SMCollectionDisposer?
    {
        didSet
        {
            registerHeaderFooterViews()
        }
    }

    open var headerTitle: String?
    open var footerTitle: String?
    
    open var headerViewNibName: String?
    open var footerViewNibName: String?
    open var headerViewClass: UICollectionReusableView.Type?
    open var footerViewClass: UICollectionReusableView.Type?

    open var headerSetupBlock: SMCollectonSectionSetupViewBlock?
    open var footerSetupBlock: SMCollectonSectionSetupViewBlock?
    
    open func setHeaderViewNibName(_ nibName: String, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock)
    {
        headerViewNibName = nibName
        headerSetupBlock = setupBlock
    }
    
    open func setFooterViewNibName(_ nibName: String, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock)
    {
        footerViewNibName = nibName
        footerSetupBlock = setupBlock
    }
    
    open func setHeaderViewClass(_ aClass: UICollectionReusableView.Type, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock)
    {
        headerViewClass = aClass
        headerSetupBlock = setupBlock
    }
    
    open func setFooterViewClass(_ aClass: UICollectionReusableView.Type, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock)
    {
        footerViewClass = aClass
        footerSetupBlock = setupBlock
    }
    
    open var headerViewIdentifier: String
    {
        return String(describing: type(of: self)) + "HeaderView"
    }
    open var footerViewIdentifier: String
    {
        return String(describing: type(of: self)) + "FooterView"
    }
    
    open var insetForSection: UIEdgeInsets?
    open var minimumLineSpacing: CGFloat?
    open var minimumInteritemSpacing: CGFloat?
    open var headerReferenceSize: CGSize?
    open var footerReferenceSize: CGSize?
    
    open func index(byVisible aCellData: SMCellData) -> Int
    {
        if  let index = visibleCellDataSource.index(where: {$0 === aCellData})
        {
            return index
        }

        return NSNotFound
    }
    
    open func registerHeaderFooterViews()
    {
        if let nibName = headerViewNibName
        {
            collectionDisposer?.collectionView?.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)
        } else if let headerViewClass = headerViewClass
        {
            collectionDisposer?.collectionView?.register(headerViewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)
        }
        
        if let nibName = footerViewNibName
        {
            collectionDisposer?.collectionView?.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        } else if let footerViewClass = headerViewClass
        {
            collectionDisposer?.collectionView?.register(footerViewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        }
    }
    

    // MARK: Cells

    open func cell(forIndexPath aIndexPath: IndexPath) -> UICollectionViewCell
    {
        let cellData: SMCollectionCellData = visibleCellData(at: aIndexPath.row)
        
        let cell: UICollectionViewCell = collectionDisposer?.collectionView?.dequeueReusableCell(withReuseIdentifier: cellData.cellIdentifier, for: aIndexPath) ?? UICollectionViewCell(frame: CGRect.zero)

        (cell as? SMCollectionCellProtocol)?.setupCellData(cellData)

        return cell
    }
}
