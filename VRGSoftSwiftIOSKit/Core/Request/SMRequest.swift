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


open class SMRequest {
    
    deinit {
        
        print(#function + " - \(type(of: self))")
    }
    
    public init() {
        
    }
    
    open var tag: Int = 0
    
    public let defaultResponseQueue: DispatchQueue = DispatchQueue.main

    open var responseBlocks: [SMResponseNode] = []
    open var executeAllResponseBlocksSync: Bool = false
        
    open func canExecute() -> Bool {
        
        return false
    }
    
    open func start() {
        
        retainSelf()
    }
    
    open func startWithResponseBlockInMainQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock) {
        
        addResponseBlock(aResponseBlock, responseQueue: DispatchQueue.main).start()
    }

    open func startWithResponseBlockInGlobalQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock) {
        
        addResponseBlock(aResponseBlock, responseQueue: DispatchQueue.global()).start()
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
    
    @discardableResult open func addResponseBlock(_ aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) -> SMRequest {
        
        responseBlocks.append(SMResponseNode(responseBlock: aResponseBlock, responseQueue: aResponseQueue))
        
        return self
    }

    open func addResponseBlockDefaultResponseQueue(_ aResponseBlock: @escaping SMRequestResponseBlock) -> SMRequest {
        
        return addResponseBlock(aResponseBlock, responseQueue: defaultResponseQueue)
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
