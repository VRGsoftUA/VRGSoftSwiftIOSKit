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
    deinit
    {
        print(#function + " - \(type(of: self))")
    }
    
    let defaultResponseQueue: DispatchQueue = DispatchQueue.main

    var responseBlocks: [SMResponseNode] = []
    var executeAllResponseBlocksSync: Bool = false
        
    func canExecute() -> Bool
    {
        return false
    }
    
    func start()
    {
        retainSelf()
    }
    
    func startWithResponseBlockInMainQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock)
    {
        addResponseBlock(aResponseBlock, responseQueue: DispatchQueue.main).start()
    }

    func startWithResponseBlockInGlobalQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock)
    {
        addResponseBlock(aResponseBlock, responseQueue: DispatchQueue.global()).start()
    }

    func isExecuting() -> Bool
    {
        return false
    }
    
    func cancel()
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
    
    @discardableResult func addResponseBlock(_ aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) -> SMRequest
    {
        responseBlocks.append(SMResponseNode(responseBlock: aResponseBlock, responseQueue: aResponseQueue))
        return self
    }

    func addResponseBlockDefaultResponseQueue(_ aResponseBlock: @escaping SMRequestResponseBlock) -> SMRequest
    {
        return addResponseBlock(aResponseBlock, responseQueue: defaultResponseQueue)
    }

    func clearAllResponseBlocks()
    {
        responseBlocks.removeAll()
    }
    
    func executeAllResponseBlocks(response aResponse: SMResponse)
    {
        for node in responseBlocks
        {
            node.responseQueue.async {
                node.responseBlock(aResponse)
            }
        }
        
        releaseSelf()
    }

    func executeSynchronouslyAllResponseBlocks(response aResponse: SMResponse)
    {
        for node in responseBlocks
        {
            node.responseQueue.sync {
                node.responseBlock(aResponse)
            }
        }
        
        releaseSelf()
    }
    
    
    // MARK: - Retain
    
    fileprivate var _self: SMRequest?
    func retainSelf()
    {
        _self = self
    }
    
    func releaseSelf()
    {
        _self = nil
    }
}
