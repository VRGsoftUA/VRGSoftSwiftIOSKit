//
//  SMModuleListPaging.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 7/6/17.
//  Copyright © 2017 semenag01. All rights reserved.
//

import UIKit

public protocol SMPagingMoreCellDataProtocol: class
{
    var needLoadMore: SMBlockAction<Any>? { get set }
}

public protocol SMPagingMoreCellProtocol: class
{
    func didBeginDataLoading()
    func didEndDataLoading()
}

public protocol SMModuleListPagingDelegate: class
{
    func willLoadMore(moduleList aModuleList: SMModuleListPaging)
}


open class SMModuleListPaging: SMModuleList, SMListAdapterMoreDelegate
{
    open var initialPageOffset: Int = 0
    open var isItemsAsPage: Bool = true
    open var pageOffset: Int = 0
    open var pageSize: Int = 10
    open var isLoadMoreDataAuto: Bool = true
    open var isLoadingMore: Bool = false
    
    override open var fetcherMessageClass: SMFetcherMessage.Type {get {return SMFetcherMessagePaging.self}}
    
    weak var pagingDelegate: SMModuleListPagingDelegate?

    required public init(listAdapter aListAdapter: SMListAdapter, initialPageOffset aInitialPageOffset: Int, isItemsAsPage aIsItemsAsPage: Bool)
    {
        super.init(listAdapter: aListAdapter)
        
        initialPageOffset = aInitialPageOffset
        isItemsAsPage = aIsItemsAsPage
        
        listAdapter.moreDelegate = self
    }
    
    required public init(listAdapter aListAdapter: SMListAdapter)
    {
        super.init(listAdapter: aListAdapter)
        
        listAdapter.moreDelegate = self
    }
    
    override open func reloadData()
    {
        if isReloading
        {
            return
        }
        
        if let nextMessage: SMFetcherMessagePaging = createFetcherMessage() as? SMFetcherMessagePaging
        {
            nextMessage.pagingOffset = initialPageOffset
            nextMessage.isReloading = true
            nextMessage.isLoadingMore = false
            
            if let canFetch: Bool = dataFetcher?.canFetchWith(message: nextMessage), canFetch
            {
                pageOffset = nextMessage.pagingOffset
                isReloading = nextMessage.isReloading
                isLoadingMore = nextMessage.isLoadingMore
            }
            
            delegate?.willReload(moduleList: self)
            
            fetchDataWith(message: nextMessage)
        }
    }
    
    open func loadMoreData()
    {
        if isReloading || isLoadingMore
        {
            return
        }

        pagingDelegate?.willLoadMore(moduleList: self)
        
        if isItemsAsPage
        {
            pageOffset += 1
        } else
        {
            pageOffset += pageSize
        }
        
        isLoadingMore = true
        
        fetchDataWith(message: createFetcherMessage())
    }

    override open func createFetcherMessage() -> SMFetcherMessage
    {
        let result: SMFetcherMessage = super.createFetcherMessage()
        
        if let result: SMFetcherMessagePaging = result as? SMFetcherMessagePaging
        {
            result.pagingOffset = pageOffset
            result.pagingSize = pageSize
            result.isReloading = isReloading
            result.isLoadingMore = isLoadingMore
        }
        
        return result
    }

    
    // MARK: - Actions
    
    @objc func loadMoreDataPressed()
    {
        loadMoreData()
    }
    
    override open func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int)
    {
        listAdapter.updateSectionWith(models: aModels, sectionIndex: aSectionIndex) {[weak self] in // swiftlint:disable:this explicit_type_interface
            
            var result: Bool = false
            
            if let strongSelf: SMModuleListPaging = self
            {
                result = (aModels.count >= strongSelf.pageSize && strongSelf.pageSize != 0)
            }
            
            return result
        }
        
        models += aModels
    }

    override open func willFetchDataWith(message aMessage: SMFetcherMessage)
    {
        if isReloading
        {
            if !isHideActivityAdapterForOneFetch
            {
                DispatchQueue.main.async {
                    self.activityAdapter?.show()
                }
            }
            
            isHideActivityAdapterForOneFetch = false

        } else if isLoadingMore
        {
            listAdapter.didBeginDataLoading()
        }
    }

    override open func didFetchDataWith(message aMessage: SMFetcherMessage, response aResponse: SMResponse)
    {
        super.didFetchDataWith(message: aMessage, response: aResponse)
        
        if let message: SMFetcherMessagePaging = aMessage as? SMFetcherMessagePaging
        {
            if aResponse.isSuccess
            {
                if message.isReloading
                {
                    models.removeAll()
                } else if message.isLoadingMore
                {
                    listAdapter.didEndDataLoading()
                }
            }
            
            if message.isReloading
            {
                isReloading = false
            } else if message.isLoadingMore
            {
                isLoadingMore = false
            }
        }
    }
    
    override open func prepareSections()
    {
        if isLoadingMore
        {
            listAdapter.cleanMoreCellData()
        } else
        {
            listAdapter.prepareSections()
        }
    }


    // MARK: SMListAdapterDelegate

    public func needLoadMore(listAdapter aListAdapter: SMListAdapter)
    {
        if isLoadMoreDataAuto
        {
            loadMoreData()
        }
    }
}


// MARK: - SMPagingMoreCellProtocol

extension SMPagingMoreCellProtocol
{
    public func didBeginDataLoading()
    {
        
    }
    
    public func didEndDataLoading()
    {
        
    }
}


// MARK: - SMModuleListPagingDelegate

extension SMModuleListPagingDelegate
{
    public func moreCellDataForPaging(moduleList aModuleList: SMModuleListPaging) -> SMPagingMoreCellDataProtocol
    {
        return SMNativeMoreTableViewCellData()
    }
    
    public func willLoadMore(moduleList aModuleList: SMModuleListPaging)
    {
        
    }
}
