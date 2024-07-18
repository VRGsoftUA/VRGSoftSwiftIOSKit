//
//  SMFetcherIntoStorage.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 7/12/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMFetcherIntoStorage: SMFetcherWithRequest {
    
    open var isFetchOnlyFromDataBase: Bool = false
    open var isFetchFromDataBaseWhenGatewayRequestFailed: Bool = false
    open var isFetchFromDataBaseWhenGatewayRequestSuccess: Bool = false
    open var isFetchFromDataBaseIfGatewayRequestIsNil: Bool = false
    
    open var currentMessage: SMFetcherMessage?
    
    
    // MARK: Request
    
    override open var request: SMRequest? {
        
        get { return _request }
        set {
            
            if _request !== newValue {
                
                self.cancelFetching()
                _request = newValue

                let requestTag: Int? = request?.tag

                _request?.addResponseBlock({[weak self] aResponse in
                    
                    guard let strongSelf: SMFetcherIntoStorage = self else { return }
                    
                    if requestTag == 0 {
                        
                        let success: Bool = aResponse.isSuccess
                        
                        if success {
                            
                            let models: [Any] = strongSelf.processFetchedModelsAfterGatewayInResponse(aResponse)
                            aResponse.boArray = models
                            
                            if strongSelf.isFetchFromDataBaseWhenGatewayRequestSuccess && strongSelf.canFetchFromDatabaseForFailedResponse(aResponse) {
                                
                                if let currentMessage: SMFetcherMessage = strongSelf.currentMessage {
                                    
                                    strongSelf.request = strongSelf.dataBaseRequestBy(message: currentMessage)
                                    strongSelf.request?.tag = 1
                                }
                                
                                if strongSelf.request != nil {
                                    
                                    strongSelf.request?.start()
                                } else {
                                    
                                    aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                                    
                                    if let fetchCallback: SMDataFetchCallback = strongSelf.fetchCallback {
                                        
                                        fetchCallback(aResponse)
                                    }
                                }
                            } else {
                                
                                aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                                
                                if let fetchCallback: SMDataFetchCallback = strongSelf.fetchCallback {
                                    
                                    fetchCallback(aResponse)
                                }
                            }
                        } else if strongSelf.isFetchFromDataBaseWhenGatewayRequestFailed && !aResponse.isCancelled && strongSelf.canFetchFromDatabaseForFailedResponse(aResponse) {
                            
                            if let currentMessage: SMFetcherMessage = strongSelf.currentMessage {
                                
                                strongSelf.request = strongSelf.dataBaseRequestBy(message: currentMessage)
                                strongSelf.request?.tag = 1
                            }
                            
                            if strongSelf.request != nil {
                                
                                strongSelf.request?.start()
                            } else {
                                
                                aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                                
                                if let fetchCallback: SMDataFetchCallback = strongSelf.fetchCallback {
                                    
                                    fetchCallback(aResponse)
                                }
                            }
                        } else {
                            
                            aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                            
                            if let fetchCallback: SMDataFetchCallback = strongSelf.fetchCallback {
                                
                                fetchCallback(aResponse)
                            }
                        }
                        
                    } else {
                        aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                        
                        if let fetchCallback: SMDataFetchCallback = strongSelf.fetchCallback {
                            
                            fetchCallback(aResponse)
                        }
                    }
                    }, responseQueue: self.callbackQueue)
            }
        }
    }
    
    override open func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest? {
        
        if let currentMessage: SMFetcherMessage = currentMessage {
            
            if  currentMessage === aMessage {
                
                return preparedRequest
            }
        }
        
        currentMessage = aMessage
        
        var newRequest: SMRequest?
        
        if !self.isFetchOnlyFromDataBase {
            
            if canExecute() {
                
                newRequest = self.gatewayRequestBy(message: aMessage)
                
                if newRequest == nil && isFetchFromDataBaseIfGatewayRequestIsNil {
                    
                    newRequest = self.dataBaseRequestBy(message: aMessage)
                    newRequest?.tag = 1
                }
                
            } else {
                
                newRequest = self.dataBaseRequestBy(message: aMessage)
                newRequest?.tag = 1
            }
        } else {
            
            newRequest = self.dataBaseRequestBy(message: aMessage)
            newRequest?.tag = 1
        }
        
        return newRequest
    }
    
    open func gatewayRequestBy(message aMessage: SMFetcherMessage) -> SMRequest? {
        // override it
        return nil
    }
    
    open func dataBaseRequestBy(message aMessage: SMFetcherMessage) -> SMRequest? {
        // override it
        return nil
    }
    
    open func canExecute() -> Bool {

        return SMGatewayConfigurator.shared.isInternetReachable()
    }
    
    // MARK: Fetch
    
    override public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback) {
        
        fetchCallback = aFetchCallback
        
        if preparedRequest == nil {
            
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        
        request = preparedRequest
        preparedRequest = nil
        
        request?.start()
    }
    
    open func processFetchedModelsAfterGatewayInResponse(_ aResponse: SMResponse) -> [Any] {
        
        return aResponse.boArray
    }
    
    open func canFetchFromDatabaseForFailedResponse(_ aResponse: SMResponse) -> Bool {
        
        return true
    }
    
    open func canFetchFromDatabaseForSuccessResponse(_ aResponse: SMResponse) -> Bool {
        
        return true
    }
}
