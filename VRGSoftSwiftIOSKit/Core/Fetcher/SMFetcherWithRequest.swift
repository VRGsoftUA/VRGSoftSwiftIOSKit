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
        
    }
    
    var preparedRequest: SMRequest?

    
    // MARK: SMDataFetcherProtocol
    
    public var callbackQueue: DispatchQueue = DispatchQueue.global()
    
    var fetchCallback: SMDataFetchCallback?
    
    public func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    {
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        
        return preparedRequest?.canExecute() ?? false
    }
    
    public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
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
    
    public func cancelFetching()
    {
        self.request?.cancel()
    }
    
    
    // MARK: Requests
    
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
            if _request !== newValue
            {
                self.cancelFetching()
                _request = newValue
                
                request?.addResponseBlock({[weak self] aResponse in
                    guard let strongSelf = self else { return }
                    aResponse.boArray = strongSelf.processFetchedModelsIn(response: aResponse)
                    
                    strongSelf.fetchCallback?(aResponse)
                    
                    }, responseQueue: self.callbackQueue)
            }
        }
        
        get { return _request }
    }
    
    func processFetchedModelsIn(response aResponse: SMResponse) -> [AnyObject]
    {
        return aResponse.boArray
    }
}
