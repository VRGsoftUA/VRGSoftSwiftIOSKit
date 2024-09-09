//
//  SMModuleListPaging.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 7/6/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public let kSMModuleListPagingPageCountResponseKey: String = "kSMModuleListPagingPageCountResponseKey"

public protocol SMPagingMoreCellDataProtocol: AnyObject {
    
    var needLoadMore: SMBlockAction<Any>? { get set }
    var didTapButtonLoadMore: SMBlockAction<Any>? { get set }
}

public protocol SMPagingMoreCellProtocol: AnyObject {
    
    func didBeginDataLoading()
    func didEndDataLoading()
}

public protocol SMModuleListPagingDelegate: AnyObject {
    
    func willLoadMore(moduleList aModuleList: SMModuleListPaging)
}


open class SMModuleListPaging: SMModuleList, SMListAdapterMoreDelegate {
    
    open var initialPageOffset: Int = 0
    open var isItemsAsPage: Bool = true
    open var pageOffset: Int = 0
    open var pageSize: Int = 10
    open var pageCount: Int?
    
    open var isLoadMoreDataAuto: Bool = true
    open var isLoadingMore: Bool = false
    
    override open var fetcherMessageClass: SMFetcherMessage.Type {get {return SMFetcherMessagePaging.self}}
    
    weak var pagingDelegate: SMModuleListPagingDelegate?

    required public init(listAdapter aListAdapter: SMListAdapter, initialPageOffset aInitialPageOffset: Int, isItemsAsPage aIsItemsAsPage: Bool) {
        super.init(listAdapter: aListAdapter)
        
        initialPageOffset = aInitialPageOffset
        isItemsAsPage = aIsItemsAsPage
        
        listAdapter.moreDelegate = self
    }
    
    required public init(listAdapter aListAdapter: SMListAdapter) {
        
        super.init(listAdapter: aListAdapter)
        
        listAdapter.moreDelegate = self
    }
    
    override open func reloadData() {
                
        if let nextMessage: SMFetcherMessagePaging = createFetcherMessage() as? SMFetcherMessagePaging {
            
            nextMessage.pagingOffset = initialPageOffset
            nextMessage.isReloading = true
            nextMessage.isLoadingMore = false
            
            if let canFetch: Bool = dataFetcher?.canFetchWith(message: nextMessage), canFetch {
                
                pageOffset = nextMessage.pagingOffset
                isReloading = nextMessage.isReloading
                isLoadingMore = nextMessage.isLoadingMore
            }
            
            delegate?.willReload(moduleList: self)
            
            fetchDataWith(message: nextMessage)
        }
    }
    
    open func loadMoreData() {
        
        if isReloading || isLoadingMore {
            
            return
        }

        pagingDelegate?.willLoadMore(moduleList: self)
        
        if isItemsAsPage {
            
            pageOffset += 1
        } else {
            
            pageOffset += pageSize
        }
        
        isLoadingMore = true
        
        fetchDataWith(message: createFetcherMessage())
    }

    override open func createFetcherMessage() -> SMFetcherMessage {
        
        let result: SMFetcherMessage = super.createFetcherMessage()
        
        if let result: SMFetcherMessagePaging = result as? SMFetcherMessagePaging {
            
            result.pagingOffset = pageOffset
            result.pagingSize = pageSize
            result.isReloading = isReloading
            result.isLoadingMore = isLoadingMore
        }
        
        return result
    }

    
    // MARK: - Actions
    
    @objc func loadMoreDataPressed() {
        
        loadMoreData()
    }
    
    override open func updateSectionWith(models aModels: [Any], originalModels: [Any], sectionIndex aSectionIndex: Int, isLastSectionForNewModels: Bool) {
        
        listAdapter.updateSectionWith(models: aModels, lastModel: models.last, sectionIndex: aSectionIndex) {[weak self] in
            
            var result: Bool = false
            
            if let strongSelf: SMModuleListPaging = self {
                
                if let pageCount: Int = self?.pageCount, strongSelf.pageSize > 0 {
                    
                    let currentPageCount: Int = strongSelf.isItemsAsPage ? strongSelf.pageOffset : strongSelf.pageOffset / strongSelf.pageSize
                    
                    result = (isLastSectionForNewModels && originalModels.fullItemsCount >= strongSelf.pageSize && strongSelf.pageSize != 0 && currentPageCount < pageCount)
                } else {
                    
                    result = (isLastSectionForNewModels && originalModels.fullItemsCount >= strongSelf.pageSize && strongSelf.pageSize != 0)
                }
            }
            
            return result
        }
        
        models += aModels
    }

    override open func willFetchDataWith(message aMessage: SMFetcherMessage) {
        
        if isReloading {
            
            if !isHideActivityAdapterForOneFetch {
                
                DispatchQueue.main.async {
                    self.activityAdapter?.show()
                }
            }
            
            isHideActivityAdapterForOneFetch = false

        } else if isLoadingMore {
            
            listAdapter.didBeginDataLoading()
        }
    }

    override open func didFetchDataWith(message aMessage: SMFetcherMessage, response aResponse: SMResponse) {
        super.didFetchDataWith(message: aMessage, response: aResponse)
        
        if let message: SMFetcherMessagePaging = aMessage as? SMFetcherMessagePaging {
            
            if aResponse.isSuccess {
                
                if message.isReloading {
                    
                    self.pageCount = aResponse.dataDictionary[kSMModuleListPagingPageCountResponseKey] as? Int
                    
                    models.removeAll()
                } else if message.isLoadingMore {
                    
                    listAdapter.didEndDataLoading()
                }
            }
            
            if message.isReloading {
                
                isReloading = false
            } else if message.isLoadingMore {
                
                isLoadingMore = false
            }
        }
    }
    
    override open func prepareSections() {
        
        if isLoadingMore {
            
            listAdapter.cleanMoreCellData()
        } else {
            
            listAdapter.prepareSections()
        }
    }


    // MARK: SMListAdapterDelegate

    public func needLoadMore(listAdapter aListAdapter: SMListAdapter) {
        
        if isLoadMoreDataAuto {
            
            loadMoreData()
        }
    }
    
    public func forceLoadMore(listAdapter aListAdapter: SMListAdapter) {
        loadMoreData()
    }
}


// MARK: - SMPagingMoreCellProtocol

extension SMPagingMoreCellProtocol {
    
    public func didBeginDataLoading() { }
    public func didEndDataLoading() { }
}


// MARK: - SMModuleListPagingDelegate

extension SMModuleListPagingDelegate {
    
    public func moreCellDataForPaging(moduleList aModuleList: SMModuleListPaging) -> SMPagingMoreCellDataProtocol {
        
        return SMNativeMoreTableViewCellData()
    }
    
    public func willLoadMore(moduleList aModuleList: SMModuleListPaging) { }
}

extension Array {
    
    var fullItemsCount: Int {
        
        var result: Int = 0
        
        result = getItemsCount(array: self)
        
        return result
    }
    
    func getItemsCount(array: Array) -> Int {
        
        var result: Int = 0
        
        if let array: [Array] = array as? [Array] {
            
            for value: Array in array {
                
                result += getItemsCount(array: value)
            }
            
        } else {
            
            result = array.count
        }
        
        return result
    }
}
