//
//  SMCollectionAdapter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMCollectionAdapter: SMListAdapter, SMCollectionDisposerMulticastDelegate
{
    override open var listDisposer: SMListDisposer? { return collectionDisposer }
    
    public let collectionDisposer: SMCollectionDisposerModeled
    
    public init(collectionDisposer aCollectionDisposer: SMCollectionDisposerModeled)
    {
        collectionDisposer = aCollectionDisposer
        super.init()
        collectionDisposer.multicastDelegate.addDelegate(self)
    }
    
    override open func prepareSections()
    {
        if delegate == nil
        {
            collectionDisposer.sections.removeAll()
            let section: SMCollectonSection = SMCollectonSection()
            collectionDisposer.addSection(section)
        } else
        {
            super.prepareSections()
        }
    }
    
    override open func cleanMoreCellData()
    {
        for section: SMCollectonSection in collectionDisposer.sections
        {
            var moreCellDatas: [SMCollectionCellData] = []
            for cd: SMCollectionCellData in section.cellDataSource where cd is SMPagingMoreCellDataProtocol
            {
                moreCellDatas.append(cd)
            }
            
            for cd: SMCollectionCellData in moreCellDatas
            {
                section.removeCellData(cd)
            }
        }
    }

    
    override open func reloadData()
    {
        collectionDisposer.reloadData()
    }
    
    override open func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int, needLoadMore aNeedLoadMore: SMListAdapterClosureType?)
    {
        var section: SMCollectonSection?
        
        if let value: SMCollectonSection = delegate?.listAdapter(self, sectionForModels: aModels, indexOfSection: aSectionIndex) as? SMCollectonSection
        {
            section = value
            collectionDisposer.addSection(value)
        } else if let value: SMCollectonSection = collectionDisposer.sections.last
        {
            section = value
        } else if let value: SMCollectonSection = delegate?.defaultSectionForlistAdapter(self) as? SMCollectonSection
        {
            section = value
            collectionDisposer.addSection(value)
        }
        
        guard let sectionForModels: SMCollectonSection = section else
        {
            assert(false, "SMCollectionAdapter: section for collectionDisposer is nil!")
            return
        }
        
        setupModels(aModels, forSection: sectionForModels)
        
        if aNeedLoadMore?() ?? false
        {
            if let moreCellData: SMPagingMoreCellDataProtocol = delegate?.moreCellDataForListAdapter(self)
            {
                if let moreCellDataType: SMCollectionCellData.Type = type(of: moreCellData) as? SMCollectionCellData.Type
                {
                    collectionDisposer.register(cellDataClass: moreCellDataType)
                    moreCellData.needLoadMore = SMBlockAction(block: { [weak self] _ in // swiftlint:disable:this explicit_type_interface
                        if let strongSelf: SMCollectionAdapter = self
                        {
                            strongSelf.moreDelegate?.needLoadMore(listAdapter: strongSelf)
                        }
                    })
                    
                    if let moreCellData: SMCollectionCellData = moreCellData as? SMCollectionCellData
                    {
                        sectionForModels.addCellData(moreCellData)
                    }
                }
            }
        }
    }
    
    func setupModels(_ aModels: [AnyObject], forSection aSection: SMCollectonSection)
    {
        collectionDisposer.setupModels(aModels, forSection: aSection)
    }
    
    
    // MARK: - SMCollectionDisposerMulticastDelegate
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if let cell: SMPagingMoreCellProtocol = cell as? SMPagingMoreCellProtocol
        {
            moreCell = cell
            moreDelegate?.needLoadMore(listAdapter: self)
        }
    }
}
