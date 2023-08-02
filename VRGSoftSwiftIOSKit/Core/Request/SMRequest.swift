//
//  SMRequest.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public typealias SMRequestResponseBlock = (SMResponse) -> Void

open class SMResponseNode {
    
    public let responseQueue: DispatchQueue
    public let responseBlock: SMRequestResponseBlock
    
    public init(responseBlock aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) {
        
        responseBlock = aResponseBlock
        responseQueue = aResponseQueue
    }
}

public enum SMRequestConsoleOutputType {
    case none
    case simply
    case debugDescription
    case cURL
}

open class SMRequest {
    
    public init() {
        
    }
    
    open var tag: Int = 0
    
    open var queue: DispatchQueue = .main
    
    open var responseBlocks: [SMResponseNode] = []
    open var executeAllResponseBlocksSync: Bool = false
        
    open func canExecute() -> Bool {
        
        return false
    }
    
    @discardableResult
    open func start() -> Self {
        
        retainSelf()
        
        return self
    }
    
    @discardableResult
    open func startWithResponseBlockInMainQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock) -> Self {
        queue = DispatchQueue.main
        return addResponseBlock(aResponseBlock, responseQueue: queue).start()
    }

    @discardableResult
    open func startWithResponseBlockInGlobalQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock) -> Self {
        queue = DispatchQueue.global()
        return addResponseBlock(aResponseBlock, responseQueue: queue).start()
    }
    
    @discardableResult
    open func startWithResponseBlock(in queue: DispatchQueue, responseBlock aResponseBlock: @escaping SMRequestResponseBlock) -> Self {
        self.queue = queue
        return addResponseBlock(aResponseBlock, responseQueue: queue).start()
    }

    open func isExecuting() -> Bool {
        
        return false
    }
    
    open func cancel() {
        
    }
    
    open func isCancelled() -> Bool {
        
        return false
    }
    
    open func isFinished() -> Bool {
        
        return false
    }
    
    @discardableResult
    open func addResponseBlock(_ aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) -> Self {
        
        responseBlocks.append(SMResponseNode(responseBlock: aResponseBlock, responseQueue: aResponseQueue))
        
        return self
    }

    open func clearAllResponseBlocks() {
        
        responseBlocks.removeAll()
    }
    
    open func executeAllResponseBlocks(response aResponse: SMResponse) {
        
        for node: SMResponseNode in responseBlocks {
            
            node.responseQueue.async {
                node.responseBlock(aResponse)
            }
        }
        
        releaseSelf()
    }

    open func executeSynchronouslyAllResponseBlocks(response aResponse: SMResponse) {
        
        for node: SMResponseNode in responseBlocks {
            
            node.responseQueue.sync {
                node.responseBlock(aResponse)
            }
        }
        
        releaseSelf()
    }
    
    
    // MARK: - Retain
    
    fileprivate var _self: SMRequest?
    func retainSelf() {
        _self = self
    }
    
    func releaseSelf() {
        _self = nil
    }
}
