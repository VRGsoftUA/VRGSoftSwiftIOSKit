//
//  SMFetcherWithArrayBlock.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 3/12/19.
//  Copyright © 2019 VRG Soft. All rights reserved.
//

import VRGSoftIOSNetworkKit

public typealias SMDataArrayFetchBlock = () -> [Any]?

open class SMFetcherWithArrayBlock: SMDataFetcherProtocol {
    
    // MARK: SMDataFetcherProtocol
    
    public var callbackQueue: DispatchQueue = DispatchQueue.global()
    
    public let fetchBlock: SMDataArrayFetchBlock
    
    
    public init(fetchBlock aFetchBlock: @escaping SMDataArrayFetchBlock) {
        
        self.fetchBlock = aFetchBlock
    }
    
    open func canFetchWith(message aMessage: SMFetcherMessage) -> Bool {
        
        return true
    }
    
    public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback) {
        
        self.callbackQueue.async {
            
            let response: SMResponse = SMResponse()
            response.isSuccess = true
            response.boArray = self.fetchBlock() as [AnyObject]? ?? []
            aFetchCallback(response)
        }
    }
    
    public func cancelFetching() {
        
    }
}
