//
//  SMTableAdapter.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/19/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit


open class SMTableAdapter: SMListAdapter, SMTableDisposerMulticastDelegate
{
    override open var listDisposer: SMListDisposer? { return tableDisposer }
    
    open let tableDisposer: SMTableDisposerModeled

    public init(tableDisposer aTableDisposer: SMTableDisposerModeled)
    {
        tableDisposer = aTableDisposer
        super.init()
        tableDisposer.multicastDelegate.addDelegate(self)
    }
    
    override open func prepareSections()
    {
        if delegate == nil
        {
            tableDisposer.sections.removeAll()
            let section = SMSectionReadonly()
            tableDisposer.addSection(section)
        } else
        {
            super.prepareSections()
        }
    }
    
    override open func cleanMoreCellData()
    {
        for section: SMSectionReadonly in tableDisposer.sections
        {
            var moreCellDatas: [SMCellData] = []
            for cd: SMCellData in section.cellDataSource where cd is SMPagingMoreCellDataProtocol
            {
                moreCellDatas.append(cd)
            }
            
            for cd: SMCellData in moreCellDatas
            {
                section.removeCellData(cd)
            }
        }
    }
    
    override open func reloadData()
    {
        tableDisposer.reloadData()
    }
    
    override open func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int, needLoadMore aNeedLoadMore: SMListAdapterClosureType?)
    {
        var section: SMSectionReadonly?
        
        if let value: SMSectionReadonly = delegate?.listAdapter(self, sectionForModels: aModels, indexOfSection: aSectionIndex) as? SMSectionReadonly
        {
            section = value
            tableDisposer.addSection(value)
        } else if let value: SMSectionReadonly = tableDisposer.sections.last
        {
            section = value
        } else if let value: SMSectionReadonly = delegate?.defaultSectionForlistAdapter(self) as? SMSectionReadonly
        {
            section = value
            tableDisposer.addSection(value)
        }
        
        guard let sectionForModels = section else
        {
            assert(false, "SMCollectionAdapter: section for collectionDisposer is nil!")
            return
        }
        
        self.setupModels(aModels, forSection: sectionForModels)
        
//        guard let sectionForModels: SMSectionReadonly = self.delegate?.listAdapter(self, sectionForModels: aModels, indexOfSection: aSectionIndex) as? SMSectionReadonly else
//        {
//            guard let sectionForModels: SMSectionReadonly = tableDisposer.sections.last else
//            {
//                return
//            }
//
//            self.setupModels(aModels, forSection: sectionForModels)
//            return
//        }
//
//        self.setupModels(aModels, forSection: sectionForModels)
        
        if aNeedLoadMore?() ?? false
        {
            if let moreCellData: SMPagingMoreCellDataProtocol = delegate?.moreCellDataForListAdapter(self)
            {
                moreCellData.needLoadMore = SMBlockAction(block: { [weak self] _ in
                    if let _self = self
                    {
                        _self.moreDelegate?.needLoadMore(listAdapter: _self)
                    }
                })
                
                if let moreCellData = moreCellData as? SMCellData
                {
                    sectionForModels.addCellData(moreCellData)
                }
            }
        }
    }
    
    open func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly)
    {
        self.tableDisposer.setupModels(aModels, forSection: aSection)
    }

    
    // MARK: - SMTableDisposerMulticastDelegate
    
    public func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)
    {
        
    }
    
    public func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if let cell = cell as? SMPagingMoreCellProtocol
        {
            moreCell = cell
            moreDelegate?.needLoadMore(listAdapter: self)
        }
    }
}
