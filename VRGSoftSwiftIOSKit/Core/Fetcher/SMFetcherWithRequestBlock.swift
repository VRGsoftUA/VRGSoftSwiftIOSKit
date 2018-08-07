//
//  SMFetcherWithRequestBlock.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 7/25/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMPrepareRequestBlock = (SMFetcherMessage) -> SMRequest
public typealias SMCanFetchBlock = (SMFetcherMessage) -> Bool

open class SMFetcherWithRequestBlock: SMFetcherWithRequest
{
    open var requestBlock: SMPrepareRequestBlock
    open var canFetchBlock: SMCanFetchBlock?
    
    public convenience init(requestBlock aRequestBlock: @escaping SMPrepareRequestBlock)
    {
       self.init(requestBlock: aRequestBlock, canFetchBlock: nil)
    }
    
    public init(requestBlock aRequestBlock: @escaping SMPrepareRequestBlock, canFetchBlock aCanFetchBlock: SMCanFetchBlock?)
    {
        requestBlock = aRequestBlock
        canFetchBlock = aCanFetchBlock
        
        super.init()
    }
    
    open override func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest?
    {
        return requestBlock(aMessage)
    }
    
   open override func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    {
        var result: Bool = false
        
        if let canFetchBlock: SMCanFetchBlock = canFetchBlock
        {
            result = canFetchBlock(aMessage)
        } else
        {
            result = super.canFetchWith(message: aMessage)
        }
        
        return result
    }
}
