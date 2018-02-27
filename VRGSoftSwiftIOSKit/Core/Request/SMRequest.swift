//
//  SMRequest.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public typealias SMRequestResponseBlock = (SMResponse) -> Void

open class SMResponseNode
{
    let responseQueue: DispatchQueue
    let responseBlock: SMRequestResponseBlock
    
    public init(responseBlock aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue)
    {
        responseBlock = aResponseBlock
        responseQueue = aResponseQueue
    }
}


open class SMRequest
{
    let defaultResponseQueue: DispatchQueue = DispatchQueue.main

    var responseBlocks: [SMResponseNode] = []
    var executeAllResponseBlocksSync: Bool = false
        
    func canExecute() -> Bool
    {
        return false
    }
    
    func start() -> Void
    {
        
    }
    
    func isExecuting() -> Bool
    {
        return false
    }
    
    func cancel() -> Void
    {
        
    }
    
    func isCancelled() -> Bool
    {
        return false
    }
    
    func isFinished() -> Bool
    {
        return false
    }
    
    func addResponseBlock(_ aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) -> SMRequest
    {
        responseBlocks.append(SMResponseNode(responseBlock: aResponseBlock, responseQueue: aResponseQueue))
        return self
    }

    func addResponseBlockDefaultResponseQueue(_ aResponseBlock: @escaping SMRequestResponseBlock) -> SMRequest
    {
        return self.addResponseBlock(aResponseBlock, responseQueue: self.defaultResponseQueue)
    }

    func clearAllResponseBlocks() -> Void
    {
        responseBlocks.removeAll()
    }
    
    func executeAllResponseBlocks(response aResponse: SMResponse) -> Void
    {
        for node in responseBlocks
        {
            node.responseQueue.async {
                node.responseBlock(aResponse)
            }
        }
    }

    func executeSynchronouslyAllResponseBlocks(response aResponse: SMResponse) -> Void
    {
        for node in responseBlocks
        {
            node.responseQueue.sync {
                node.responseBlock(aResponse)
            }
        }
    }
}
