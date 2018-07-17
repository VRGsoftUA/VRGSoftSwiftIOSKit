//
//  SMFetcherIntoStorage.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 7/12/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMFetcherIntoStorage: SMFetcherWithRequest
{
    var isFetchOnlyFromDataBase: Bool = false
    var isFetchFromDataBaseWhenGatewayRequestFailed: Bool = false
    var isFetchFromDataBaseWhenGatewayRequestSuccess: Bool = false
    
    var currentMessage: SMFetcherMessage?
    
    
    // MARK: Request
    
    override open var request: SMRequest?
    {
        set
        {
            if _request !== newValue
            {
                self.cancelFetching()
                _request = newValue
                
                _request?.addResponseBlock({[weak self] aResponse in
                    
                    guard let strongSelf = self else { return }
                    
                    if newValue is SMGatewayRequest
                    {
                        let success: Bool = aResponse.isSuccess
                        if success
                        {
                            let models = strongSelf.processFetchedModelsAfterGatewayInResponse(aResponse)
                            aResponse.boArray = models
                            
                            if strongSelf.isFetchFromDataBaseWhenGatewayRequestSuccess && strongSelf.canFetchFromDatabaseForFailedResponse(aResponse)
                            {
                                if let currentMessage: SMFetcherMessage = strongSelf.currentMessage
                                {
                                    strongSelf.request = strongSelf.dataBaseRequestBy(message: currentMessage)
                                }
                                
                                if strongSelf.request != nil
                                {
                                    strongSelf.request?.start()
                                } else
                                {
                                    aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                                    
                                    if let fetchCallback = strongSelf.fetchCallback
                                    {
                                        fetchCallback(aResponse)
                                    }
                                }
                            } else
                            {
                                aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                                
                                if let fetchCallback = strongSelf.fetchCallback
                                {
                                    fetchCallback(aResponse)
                                }
                            }
                        } else if strongSelf.isFetchFromDataBaseWhenGatewayRequestFailed && !aResponse.isCancelled && strongSelf.canFetchFromDatabaseForFailedResponse(aResponse)
                        {
                            if let currentMessage: SMFetcherMessage = strongSelf.currentMessage
                            {
                                strongSelf.request = strongSelf.dataBaseRequestBy(message: currentMessage)
                            }
                            
                            if strongSelf.request != nil
                            {
                                strongSelf.request?.start()
                            } else
                            {
                                aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                                
                                if let fetchCallback = strongSelf.fetchCallback
                                {
                                    fetchCallback(aResponse)
                                }
                            }
                        } else
                        {
                            aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                            
                            if let fetchCallback = strongSelf.fetchCallback
                            {
                                fetchCallback(aResponse)
                            }
                        }
                        
                    } else
                    {
                        aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                        
                        if let fetchCallback = strongSelf.fetchCallback
                        {
                            fetchCallback(aResponse)
                        }
                    }
                    }, responseQueue: self.callbackQueue)
            }
        }
        
        get { return _request }
    }
    
    override public func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest?
    {
        if let currentMessage = currentMessage
        {
            if  currentMessage === aMessage
            {
                return preparedRequest
            }
        }
        
        currentMessage = aMessage
        
        var newRequest: SMRequest?
        if !self.isFetchOnlyFromDataBase
        {
            if SMGatewayConfigurator.shared.isInternetReachable()
            {
                newRequest = self.gatewayRequestBy(message: aMessage)
            } else
            {
                newRequest = self.dataBaseRequestBy(message: aMessage)
            }
        } else
        {
            newRequest = self.dataBaseRequestBy(message: aMessage)
        }
        
        return newRequest
    }
    
    func gatewayRequestBy(message aMessage: SMFetcherMessage) -> SMGatewayRequest?
    {
        //override it
        return nil
    }
    
    func dataBaseRequestBy(message aMessage: SMFetcherMessage) -> SMDBRequest?
    {
        //override it
        return nil
    }
    
    
    // MARK: Fetch
    
    override public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
    {
        fetchCallback = aFetchCallback
        
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        
        request = preparedRequest
        preparedRequest = nil
        
        request?.start()
    }
    
    func processFetchedModelsAfterGatewayInResponse(_ aResponse: SMResponse) -> [AnyObject]
    {
        return aResponse.boArray
    }
    
    func canFetchFromDatabaseForFailedResponse(_ aResponse: SMResponse) -> Bool
    {
        return true
    }
    
    func canFetchFromDatabaseForSuccessResponse(_ aResponse: SMResponse) -> Bool
    {
        return true
    }
}
