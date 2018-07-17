//
//  SMListAdapter.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/19/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

public typealias SMListAdapterClosureType = () -> Bool

public protocol SMListAdapterDelegate: class
{
    func prepareSectionsFor(listAdapter aListAdapter: SMListAdapter)
    func defaultSectionForlistAdapter(_ aListAdapter: SMListAdapter) -> Any?
    func listAdapter(_ aListAdapter: SMListAdapter, sectionForModels aModels: [AnyObject], indexOfSection aIndex: Int) -> Any?
    func moreCellDataForListAdapter(_ aListAdapter: SMListAdapter) -> SMPagingMoreCellDataProtocol?
}


public protocol SMListAdapterMoreDelegate: class
{
    func needLoadMore(listAdapter aListAdapter: SMListAdapter)
}


open class SMListAdapter: Any
{
    var listDisposer: SMListDisposer?
    {
        return nil
    }
    var moreCell: SMPagingMoreCellProtocol?

    weak var moreDelegate: SMListAdapterMoreDelegate?
    weak var delegate: SMListAdapterDelegate?
    
    open func reloadData()
    {
        
    }
    
    open func prepareSections()
    {
        delegate?.prepareSectionsFor(listAdapter: self)
    }
    
    open func cleanMoreCellData()
    {
        
    }
    
    open func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int, needLoadMore aNeedLoadMore: SMListAdapterClosureType?)
    {
        
    }
    
    
    // MARK: - Load More
    
    open func didBeginDataLoading()
    {
        moreCell?.didBeginDataLoading()
    }
    
    open func didEndDataLoading()
    {
        moreCell?.didEndDataLoading()
    }
}