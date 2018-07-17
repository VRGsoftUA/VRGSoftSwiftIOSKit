//
//  SMCollectionAdapter.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

class SMCollectionAdapter: SMListAdapter, SMCollectionDisposerMulticastDelegate
{
    override var listDisposer: SMListDisposer? { return collectionDisposer }
    
    let collectionDisposer: SMCollectionDisposerModeled
    
    init(collectionDisposer aCollectionDisposer: SMCollectionDisposerModeled)
    {
        collectionDisposer = aCollectionDisposer
        super.init()
        collectionDisposer.multicastDelegate.addDelegate(self)
    }
    
    override func prepareSections()
    {
        if delegate == nil
        {
            collectionDisposer.sections.removeAll()
            let section = SMCollectonSection()
            collectionDisposer.addSection(section)
        } else
        {
            super.prepareSections()
        }
    }
    
    override func cleanMoreCellData()
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

    
    override func reloadData()
    {
        collectionDisposer.reloadData()
    }
    
    override func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int, needLoadMore aNeedLoadMore: SMListAdapterClosureType?)
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
        
        guard let sectionForModels = section else
        {
            assert(false, "SMCollectionAdapter: section for collectionDisposer is nil!")
            return
        }
        
        setupModels(aModels, forSection: sectionForModels)
        
        if aNeedLoadMore?() ?? false
        {
            if let moreCellData: SMPagingMoreCellDataProtocol = delegate?.moreCellDataForListAdapter(self)
            {
                if let moreCellDataType = type(of: moreCellData) as? SMCollectionCellData.Type
                {
                    collectionDisposer.register(cellDataClass: moreCellDataType)
                    moreCellData.needLoadMore = SMBlockAction(block: { [weak self] _ in
                        if let strongSelf = self
                        {
                            strongSelf.moreDelegate?.needLoadMore(listAdapter: strongSelf)
                        }
                    })
                    
                    if let moreCellData = moreCellData as? SMCollectionCellData
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
        if let cell = cell as? SMPagingMoreCellProtocol
        {
            moreCell = cell
            moreDelegate?.needLoadMore(listAdapter: self)
        }
    }
}