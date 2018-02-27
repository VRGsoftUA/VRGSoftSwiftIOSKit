//
//  SMFetcherWithRequest.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 7/5/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMFetcherWithRequest: SMDataFetcherProtocol
{
    deinit
    {
        self.callbackQueue = nil
    }
    
    var preparedRequest: SMRequest?

    
    // MARK: SMDataFetcherProtocol
    
    public var callbackQueue: DispatchQueue?
    
    var fetchCallback: SMDataFetchCallback?
    
    public func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    {
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        
        return (preparedRequest!.canExecute())
    }
    
    public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
    {
        fetchCallback = aFetchCallback
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        _request = preparedRequest
        preparedRequest = nil
        
        _request?.start()
    }
    
    public func cancelFetching()
    {
        self.request?.cancel()
    }
    
    
    //MARK: Requests
    
    func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest?
    {
        assert(false, "Override this method!")
        return nil
    }
    
    var _request: SMRequest?
    var request: SMRequest?
    {
        set
        {
            assert(self.callbackQueue != nil, "SMFetcherWithRequest: callbackQueue is nil! Setup callbackQueue before setup request.")

            if _request !== newValue
            {
                self.cancelFetching()
                _request = newValue
                
                let _ = request!.addResponseBlock({[unowned self] (aResponse) in
                    aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                    
                    if self.fetchCallback != nil
                    {
                        self.fetchCallback!(aResponse)
                    }
                    
                    }, responseQueue: self.callbackQueue!)
            }
        }
        
        get { return _request }
    }
    
    func processFetchedModelsIn(response aResponse: SMResponse) -> [AnyObject]
    {
        return aResponse.boArray
    }
}


