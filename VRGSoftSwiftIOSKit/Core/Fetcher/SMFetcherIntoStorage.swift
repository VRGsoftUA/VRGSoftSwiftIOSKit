//
//  SMFetcherIntoStorage.swift
//  mygoal
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
    
    
    //MARK: Request
    
    override var request: SMRequest?
    {
        set
        {
            assert(self.callbackQueue != nil, "SMFetcherWithRequest: callbackQueue is nil! Setup callbackQueue before setup request.")
            
            if _request != newValue
            {
                self.cancelFetching()
                _request = newValue
                
                let _: SMRequest = _request!.addResponseBlock({[unowned self] (aResponse) in
                    if newValue is SMGatewayRequest
                    {
                        let success: Bool = aResponse.success
                        if success
                        {
                            let models = self.processFetchedModelsAfterGatewayInResponse(aResponse)
                            aResponse.boArray = models
                            
                            if self.isFetchFromDataBaseWhenGatewayRequestSuccess && self.canFetchFromDatabaseForFailedResponse(aResponse)
                            {
                                self.request = self.dataBaseRequestBy(message: self.currentMessage!)
                                
                                if self.request != nil
                                {
                                    self.request!.start()
                                } else
                                {
                                    aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                                    
                                    if self.fetchCallback != nil
                                    {
                                        self.fetchCallback!(aResponse)
                                    }
                                }
                            } else
                            {
                                aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                                
                                if self.fetchCallback != nil
                                {
                                    self.fetchCallback!(aResponse)
                                }
                            }
                        } else if self.isFetchFromDataBaseWhenGatewayRequestFailed && !aResponse.requestCancelled && self.canFetchFromDatabaseForFailedResponse(aResponse)
                        {
                            self.request = self.dataBaseRequestBy(message: self.currentMessage!)
                            
                            if self.request != nil
                            {
                                self.request!.start()
                            } else
                            {
                                aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                                
                                if self.fetchCallback != nil
                                {
                                    self.fetchCallback!(aResponse)
                                }
                            }
                        } else
                        {
                            aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                            
                            if self.fetchCallback != nil
                            {
                                self.fetchCallback!(aResponse)
                            }
                        }
                        
                    } else
                    {
                        aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                        
                        if self.fetchCallback != nil
                        {
                            self.fetchCallback!(aResponse)
                        }
                    }
                    }, responseQueue: self.callbackQueue!)
            }
        }
        
        get { return _request }
    }
    
    override func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest?
    {
        if currentMessage == aMessage
        {
            return preparedRequest!
        }
        
        currentMessage = aMessage
        
        var newRequest: SMRequest
        if !self.isFetchOnlyFromDataBase
        {
            if SMGatewayConfigurator.shared.isInternetReachable()
            {
                newRequest = self.gatewayRequestBy(message: aMessage)!
            } else
            {
                newRequest = self.dataBaseRequestBy(message: aMessage)!
            }
        } else
        {
            newRequest = self.dataBaseRequestBy(message: aMessage)!
        }
        
        return newRequest
    }
    
    func gatewayRequestBy(message aMessage: SMFetcherMessage) -> SMGatewayRequest?
    {
        //override it
        return nil
    }
    
    func dataBaseRequestBy(message aMessage: SMFetcherMessage) -> SMDataBaseRequest?
    {
        //override it
        return nil
    }
    
    
    //MARK: Fetch
    
    override public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
    {
        fetchCallback = aFetchCallback
        
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        
        request = preparedRequest
        preparedRequest = nil
        
        request!.start()
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

