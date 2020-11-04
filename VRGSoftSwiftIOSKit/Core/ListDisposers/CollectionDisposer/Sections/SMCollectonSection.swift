//
//  SMCollectonSection.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMCollectonSectionSetupViewBlock = (UICollectionReusableView) -> Void

open class SMCollectonSection: SMListSection {
    
    open override var disposer: SMListDisposer? {
        
        didSet {
            registerHeaderFooterViews()
        }
    }
    
    open var collectionDisposer: SMCollectionDisposer? {
        return disposer as? SMCollectionDisposer
    }

    open var headerTitle: String?
    open var footerTitle: String?
    
    open var headerViewNibName: String?
    open var footerViewNibName: String?
    open var headerViewClass: UICollectionReusableView.Type?
    open var footerViewClass: UICollectionReusableView.Type?

    open var headerSetupBlock: SMCollectonSectionSetupViewBlock?
    open var footerSetupBlock: SMCollectonSectionSetupViewBlock?
    
    open func setHeaderViewNibName(_ nibName: String, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock) {
        
        headerViewNibName = nibName
        headerSetupBlock = setupBlock
    }
    
    open func setFooterViewNibName(_ nibName: String, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock) {
        
        footerViewNibName = nibName
        footerSetupBlock = setupBlock
    }
    
    open func setHeaderViewClass(_ aClass: UICollectionReusableView.Type, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock) {
        
        headerViewClass = aClass
        headerSetupBlock = setupBlock
    }
    
    open func setFooterViewClass(_ aClass: UICollectionReusableView.Type, withSetupBlock setupBlock: @escaping SMCollectonSectionSetupViewBlock) {
        
        footerViewClass = aClass
        footerSetupBlock = setupBlock
    }
    
    open var headerViewIdentifier: String? {

        if let headerClass = headerViewClass {

            return String(describing: headerClass)
        } else {

            return headerViewNibName
        }
    }
    
    open var footerViewIdentifier: String? {

       if let footerClass = footerViewClass {

            return String(describing: footerClass)
        } else {

            return footerViewNibName
        }
    }
    
    open var insetForSection: UIEdgeInsets?
    open var minimumLineSpacing: CGFloat?
    open var minimumInteritemSpacing: CGFloat?
    open var headerReferenceSize: CGSize?
    open var footerReferenceSize: CGSize?
    
    open func index(byVisible aCellData: SMCellData) -> Int {
        
        if  let index: Int = visibleCellDataSource.firstIndex(where: {$0 === aCellData}) {
            
            return index
        }

        return NSNotFound
    }
    
    open func registerHeaderFooterViews() {
        
        if let nibName: String = headerViewNibName {
            
            collectionDisposer?.collectionView?.register(
                UINib(nibName: nibName, bundle: nil),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: nibName
            )
        } else if let headerViewClass: UICollectionReusableView.Type = headerViewClass {

            collectionDisposer?.collectionView?.register(
                headerViewClass,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: headerViewClass)
            )
        }
        
        if let nibName: String = footerViewNibName {
            
            collectionDisposer?.collectionView?.register(
                UINib(nibName: nibName, bundle: nil),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: nibName
            )
        } else if let footerViewClass: UICollectionReusableView.Type = headerViewClass {
            
            collectionDisposer?.collectionView?.register(
                footerViewClass,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: String(describing: footerViewClass)
            )
        }
    }
    

    // MARK: Cells

    open func cell(forIndexPath aIndexPath: IndexPath) -> UICollectionViewCell {
        
        let cellData: SMListCellData = visibleCellData(at: aIndexPath.row)
        
        let cell: UICollectionViewCell = collectionDisposer?.collectionView?.dequeueReusableCell(withReuseIdentifier: cellData.cellIdentifier, for: aIndexPath) ?? UICollectionViewCell(frame: CGRect.zero)

        (cell as? SMCellProtocol)?.setupCellData(cellData)

        return cell
    }
}
