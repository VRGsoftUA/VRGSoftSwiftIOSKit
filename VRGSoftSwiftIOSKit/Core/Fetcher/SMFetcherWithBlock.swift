//
//  SMFetcherWithBlock.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 3/23/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

public typealias SMDataFetchBlock = (SMFetcherMessage, @escaping SMDataFetchCallback) -> Void


open class SMFetcherWithBlock: SMDataFetcherProtocol
{
    // MARK: SMDataFetcherProtocol
    
    public var callbackQueue: DispatchQueue = DispatchQueue.global()
    
    public let fetchBlock: SMDataFetchBlock
    
    
    public init(fetchBlock aFetchBlock: @escaping SMDataFetchBlock)
    {
        self.fetchBlock = aFetchBlock
    }
    
    open func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    {
        return true
    }
    
    public func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
    {
        self.callbackQueue.async
        {
            self.fetchBlock(aMessage, aFetchCallback)
        }
    }
    
    public func cancelFetching()
    {
        
    }
}
