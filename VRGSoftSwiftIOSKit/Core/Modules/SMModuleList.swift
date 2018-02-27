//
//  SMModuleList.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

typealias SMModuleListFetcherFailedCallback = (SMModuleList, SMResponse) -> Void
typealias SMModuleListFetcherCantFetch = (SMModuleList, SMFetcherMessage) -> Void


public protocol SMModuleListDelegate: class
{
    func fetcherMessageFor(moduleList aModule: SMModuleList) -> SMFetcherMessage
    func willReload(moduleList aModule: SMModuleList) -> Void
    func moduleList(_ aModule: SMModuleList, processFetchedModelsInResponse aResponse: SMResponse) -> [AnyObject]
    func prepareSectionsFor(moduleList aModule: SMModuleList) -> Void
    func moduleList(_ aModule: SMModuleList, sectionForModels aModels: [AnyObject], indexOfSection aIndex: Int) -> SMSectionReadonly?
    func moduleList(_ aModule: SMModuleList, didReloadDataWithModels aModels: [AnyObject]) -> Void
}

open class SMModuleList
{
    var moduleQueue: DispatchQueue = DispatchQueue(label: "SMModuleList.Queue")
    var lastUpdateDate: Date?
    var models: [AnyObject] = []
    
    var tableDisposer: SMTableDisposerModeled?
    
    var isReloading : Bool = false
    
    var pullToRefreshAdapter: SMPullToRefreshAdapter?
    {
        didSet
        {
            pullToRefreshAdapter?.refreshCallback = { [weak self] (aPullToRefreshAdapter: SMPullToRefreshAdapter) in
                
                if let __self = self
                {
                    if !__self.isUseActivityAdapterWithPullToRefreshAdapter
                    {
                        __self.isHideActivityAdapterForOneFetch = true
                    }
                    
                    __self.reloadData()
                }
            }
        }
    }
    var activityAdapter: SMActivityAdapter?
    var isUseActivityAdapterWithPullToRefreshAdapter: Bool = false
    var isHideActivityAdapterForOneFetch: Bool = false
    var fetcherMessageClass: SMFetcherMessage.Type {get {return SMFetcherMessage.self}}
    var fetcherFailedCallback: SMModuleListFetcherFailedCallback?
    var fetcherCantFetchCallback: SMModuleListFetcherCantFetch?
    
    
    weak var delegate: SMModuleListDelegate?
    
    var dataFetcher: SMDataFetcherProtocol?
    {
        didSet
        {
            dataFetcher?.callbackQueue = self.moduleQueue
        }
    }
    
    required public init(tableDisposer aTableDisposer: SMTableDisposerModeled)
    {
        self.tableDisposer = aTableDisposer
    }
    
    open func reloadData() -> Void
    {
        if isReloading
        {
            return
        }
        
        isReloading = true
        self.models.removeAll()
        
        self.delegate?.willReload(moduleList: self)
        
        self.fetchDataWith(message: self.createFetcherMessage())
    }
    
    open func configureWith(scrollView aScrollView: UIScrollView) -> Void
    {
        pullToRefreshAdapter?.configureWith(scrollView: aScrollView)
        activityAdapter?.configureWith(view: aScrollView)
    }

    func processFetchedModelsIn(response aResponse: SMResponse) -> [AnyObject]
    {
        let result: [AnyObject] = self.delegate?.moduleList(self, processFetchedModelsInResponse: aResponse) ?? []
        return result
    }

    func prepareSections() -> Void
    {
        guard let delegate = delegate else
        {
            self.tableDisposer?.sections.removeAll()
            let section = SMSectionReadonly()
            self.tableDisposer?.addSection(section)
            
            return
        }
        
        delegate.prepareSectionsFor(moduleList: self)
    }
    
    func fetchDataWith(message aMessage: SMFetcherMessage) -> Void
    {
        if self.dataFetcher != nil && self.dataFetcher!.canFetchWith(message: aMessage)
        {
            self.dataFetcher?.cancelFetching()
            self.willFetchDataWith(message: aMessage)
            weak var __self = self

            self.dataFetcher?.fetchDataBy(message: aMessage, withCallback: { (aResponse: SMResponse) in
                DispatchQueue.main.sync {
                    
                    __self?.didFetchDataWith(message: aMessage, response: aResponse)
                    
                    if aResponse.isSuccess
                    {
                        let aModels: [AnyObject] = (__self?.processFetchedModelsIn(response: aResponse))!
                        
                        __self?.prepareSections()
                        
                        var numberOfPrepareSections: Int = 0
                        
                        if aModels.count != 0
                        {
                            for var i in (0..<aModels.count)
                            {
                                let obj: AnyObject = aModels[i]
                                
                                var ms: [AnyObject]
                                
                                if obj is [AnyObject]
                                {
                                    ms = obj as! [AnyObject]
                                } else
                                {
                                    var mutMs: [AnyObject] = []
                                    for j in (i..<aModels.count)
                                    {
                                        i = j
                                        
                                        if !(aModels[j] is [AnyObject])
                                        {
                                            mutMs.append(aModels[j])
                                        } else
                                        {
                                            i -= 1
                                            break
                                        }
                                    }
                                    
                                    ms = mutMs
                                }
                                __self?.updateSectionWith(models: ms, sectionIndex: numberOfPrepareSections)
                                numberOfPrepareSections += 1
                            }
                        } else
                        {
                            __self?.updateSectionWith(models: aModels, sectionIndex: numberOfPrepareSections)
                            numberOfPrepareSections += 1
                        }
                        
                        __self?.tableDisposer!.reloadData()
                        __self?.delegate?.moduleList(__self!, didReloadDataWithModels: aModels)
                    } else
                    {
                        if !aResponse.requestCancelled && __self?.fetcherFailedCallback != nil
                        {
                            __self?.fetcherFailedCallback!(__self!,aResponse)
                        }
                    }
                }
            })
        } else
        {
            self.pullToRefreshAdapter?.endPullToRefresh()
            
            if self.fetcherCantFetchCallback != nil
            {
                self.fetcherCantFetchCallback!(self,aMessage)
            }
        }
    }
    
    func createFetcherMessage() -> SMFetcherMessage
    {
        guard let message: SMFetcherMessage = self.delegate?.fetcherMessageFor(moduleList: self) else
        {
            return fetcherMessageClass.init()
        }

        return message
    }
    
    func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int) -> Void
    {
        guard let sectionForModels: SMSectionReadonly = self.delegate?.moduleList(self, sectionForModels: aModels, indexOfSection: aSectionIndex) else
        {
            guard let sectionForModels: SMSectionReadonly = self.tableDisposer?.sections.last else
            {
                return
            }
            
            self.setupModels(aModels, forSection: sectionForModels)
            return
        }

        self.setupModels(aModels, forSection: sectionForModels)
    }
    
    func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly) -> Void
    {
        self.models += aModels
        
        self.tableDisposer!.setupModels(aModels, forSection: aSection)
    }
    
    func willFetchDataWith(message aMessage: SMFetcherMessage) -> Void
    {
        if !self.isHideActivityAdapterForOneFetch
        {
            self.isHideActivityAdapterForOneFetch = false
            DispatchQueue.main.async {
                self.activityAdapter?.show()
            }
        }
    }
    
    func didFetchDataWith(message aMessage: SMFetcherMessage, response aResponse: SMResponse) -> Void
    {
        self.isReloading = false
        self.activityAdapter?.hide()
        self.pullToRefreshAdapter?.endPullToRefresh()
    }
}


extension SMModuleListDelegate
{
    func fetcherMessageFor(moduleList aModule: SMModuleList) -> SMFetcherMessage
    {
        return SMFetcherMessage()
    }
    
    func willReload(moduleList aModule: SMModuleList) -> Void
    {
        
    }
    
    func moduleList(_ aModule: SMModuleList, processFetchedModelsInResponse aResponse: SMResponse) -> [AnyObject]
    {
        return aResponse.boArray
    }
    
    func prepareSectionsFor(moduleList aModule: SMModuleList) -> Void
    {
        aModule.tableDisposer?.sections.removeAll()
        aModule.tableDisposer?.addSection(SMSectionReadonly())
    }
    
    func moduleList(_ aModule: SMModuleList, sectionForModels aModels: [AnyObject], indexOfSection aIndex: Int) -> SMSectionReadonly?
    {
        return nil
    }
    
    func moduleList(_ aModule: SMModuleList, didReloadDataWithModels aModels: [AnyObject]) -> Void
    {
        
    }
}
