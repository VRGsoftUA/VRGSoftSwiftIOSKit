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
    func addTarget(_ aTarget: Any, action aAction:Selector) -> Void
}

public protocol SMPagingMoreCellProtocol: class
{
    func didBeginDataLoading() -> Void
    func didEndDataLoading() -> Void
}

public protocol SMModuleListPagingDelegate: class
{
    func moreCellDataForPaging(moduleList aModuleList: SMModuleListPaging) -> SMPagingMoreCellDataProtocol
    func willLoadMore(moduleList aModuleList: SMModuleListPaging) -> Void
}


open class SMModuleListPaging: SMModuleList, SMTableDisposerMulticastDelegate
{
    var initialPageOffset : Int = 0
    var isItemsAsPage : Bool = false
    var pageOffset : Int = 0
    var pageSize : Int = 20
    var isLoadMoreDataAuto : Bool = true
    var isLoadingMore : Bool = false
    
    var moreCell: SMPagingMoreCellProtocol?
    
    override var fetcherMessageClass: SMFetcherMessage.Type {get {return SMFetcherMessagePaging.self}}
    
    weak var pagingDelegate: SMModuleListPagingDelegate?

    required public init(tableDisposer aTableDisposer: SMTableDisposerModeled, initialPageOffset aInitialPageOffset: Int, isItemsAsPage aIsItemsAsPage: Bool)
    {
        super.init(tableDisposer: aTableDisposer)
        
        self.initialPageOffset = aInitialPageOffset
        self.isItemsAsPage = aIsItemsAsPage
        
        self.tableDisposer!.multicastDelegate.addDelegate(self)
    }
    
    required public init(tableDisposer aTableDisposer: SMTableDisposerModeled)
    {
        super.init(tableDisposer: aTableDisposer)
        
        self.tableDisposer!.multicastDelegate.addDelegate(self)
    }
    
    override open func reloadData()
    {
        if isReloading
        {
            return
        }
        
        let nextMessage: SMFetcherMessagePaging = self.createFetcherMessage() as! SMFetcherMessagePaging
        
        nextMessage.pagingOffset = self.initialPageOffset
        nextMessage.isReloading = true
        nextMessage.isLoadingMore = false
        
        if let canFetch = self.dataFetcher?.canFetchWith(message: nextMessage), canFetch
        {
            pageOffset = nextMessage.pagingOffset
            isReloading = nextMessage.isReloading
            isLoadingMore = nextMessage.isLoadingMore
        }
        
        self.delegate?.willReload(moduleList: self)
        
        self.fetchDataWith(message: nextMessage)
    }
    
    func loadMoreData() -> Void
    {
        if isReloading || isLoadingMore
        {
            return
        }

        self.pagingDelegate?.willLoadMore(moduleList: self)
        
        if isItemsAsPage
        {
            pageOffset += 1
        } else
        {
            pageOffset += pageSize
        }
        
        isLoadingMore = true
        
        self.fetchDataWith(message: self.createFetcherMessage())
    }

    override func createFetcherMessage() -> SMFetcherMessage
    {
        let result: SMFetcherMessagePaging = super.createFetcherMessage() as! SMFetcherMessagePaging
        
        result.pagingOffset = pageOffset
        result.pagingSize = pageSize
        result.isReloading = isReloading
        result.isLoadingMore = isLoadingMore
        
        return result
    }
    
    func setupMoreCellDataFor(section aSection: SMSectionReadonly, pagedModelsCount aPagedModelsCount: Int) -> Bool
    {
        moreCell = nil
        
        if let pagingDelegate = pagingDelegate, (aPagedModelsCount == self.pageSize && self.pageSize != 0)
        {
            let moreCellData: SMPagingMoreCellDataProtocol = pagingDelegate.moreCellDataForPaging(moduleList: self)
            moreCellData.addTarget(self, action: #selector(SMModuleListPaging.loadMoreDataPressed))
            aSection.addCellData(moreCellData as! SMCellData)
            
            return true
        }
        
        return false
    }
    
    
    // MARK: - Actions
    
    @objc func loadMoreDataPressed() -> Void
    {
        self.loadMoreData()
    }

    override func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly)
    {
        models.append(contentsOf: aModels)
        
        self.tableDisposer?.setupModels(models, forSection: aSection)
        
        let _ = self.setupMoreCellDataFor(section: aSection, pagedModelsCount: aModels.count)
    }
    
    override func willFetchDataWith(message aMessage: SMFetcherMessage)
    {
        if self.isReloading
        {
            if !self.isHideActivityAdapterForOneFetch
            {
                DispatchQueue.main.async {
                    if self.activityAdapter != nil
                    {
                        self.activityAdapter!.show()
                    }
                }
            }
            
            self.isHideActivityAdapterForOneFetch = false

        } else if self.isLoadingMore
        {
            self.moreCell?.didBeginDataLoading()
        }
    }

    override func didFetchDataWith(message aMessage: SMFetcherMessage, response aResponse: SMResponse)
    {
        super.didFetchDataWith(message: aMessage, response: aResponse)
        
        let message: SMFetcherMessagePaging = aMessage as! SMFetcherMessagePaging
        
        if aResponse.isSuccess
        {
            if message.isReloading
            {
                models .removeAll()
            } else if message.isLoadingMore
            {
                self.moreCell?.didEndDataLoading()
            }
        }
        
        if message.isReloading
        {
            self.isReloading = false
        } else if message.isLoadingMore
        {
            isLoadingMore = false
        }
    }
    
    
    // MARK: SMTableDisposerMulticastDelegate
    
    public func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if cell is SMPagingMoreCellProtocol
        {
            moreCell = (cell as! SMPagingMoreCellProtocol)
            
            if self.isLoadMoreDataAuto
            {
                self.loadMoreData()
            }
        }
    }
}


extension SMPagingMoreCellDataProtocol
{
    public func addTarget(_ aTarget: Any, action aAction:Selector) -> Void
    {
        
    }
}

extension SMPagingMoreCellProtocol
{
    public func didBeginDataLoading() -> Void
    {
        
    }
    
    public func didEndDataLoading() -> Void
    {
        
    }
}

extension SMModuleListPagingDelegate
{
    public func moreCellDataForPaging(moduleList aModuleList: SMModuleListPaging) -> SMPagingMoreCellDataProtocol
    {
        return SMNativeMoreTableViewCellData()
    }
    
    public func willLoadMore(moduleList aModuleList: SMModuleListPaging) -> Void
    {
        
    }
}

