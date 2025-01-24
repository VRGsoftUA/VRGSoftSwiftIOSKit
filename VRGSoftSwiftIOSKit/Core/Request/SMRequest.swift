//
//  SMRequest.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public typealias SMRequestResponseBlock = (SMResponse) -> Void
public typealias SMRequestProgressBlock = (SMRequest, Progress) -> Void

open class SMResponseNode {
    
    public let responseQueue: DispatchQueue
    public let responseBlock: SMRequestResponseBlock

    public init(responseBlock aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) {
        
        responseBlock = aResponseBlock
        responseQueue = aResponseQueue
    }
}

open class SMRequestProgressNode {
    
    public let requestQueue: DispatchQueue
    public let requestProgressBlock: SMRequestProgressBlock

    public init(requestProgressBlock anProgressBlock: @escaping SMRequestProgressBlock, requestQueue aRequestQueue: DispatchQueue) {
        
        requestProgressBlock = anProgressBlock
        requestQueue = aRequestQueue
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

    open var responseBlocks: [SMResponseNode] = []
    open var uploadProgressBlocks: [SMRequestProgressNode] = []
    open var downloadProgressBlocks: [SMRequestProgressNode] = []
    
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
        return addResponseBlock(aResponseBlock, responseQueue: .main).start()
    }

    @discardableResult
    open func startWithResponseBlockInGlobalQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock) -> Self {
        return addResponseBlock(aResponseBlock, responseQueue: .global(qos: .default)).start()
    }
    
    @discardableResult
    open func startWithResponseBlock(in queue: DispatchQueue, responseBlock aResponseBlock: @escaping SMRequestResponseBlock) -> Self {
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
    open func addUploadProgressBlock(_ anProgressBlock: @escaping SMRequestProgressBlock, responseQueue aResponseQueue: DispatchQueue) -> Self {
        
        uploadProgressBlocks.append(SMRequestProgressNode(requestProgressBlock: anProgressBlock, requestQueue: aResponseQueue))
        
        return self
    }

    @discardableResult
    open func addDownloadProgressBlock(_ anProgressBlock: @escaping SMRequestProgressBlock, responseQueue aResponseQueue: DispatchQueue) -> Self {
        
        downloadProgressBlocks.append(SMRequestProgressNode(requestProgressBlock: anProgressBlock, requestQueue: aResponseQueue))
        
        return self
    }

    @discardableResult
    open func addResponseBlock(_ aResponseBlock: @escaping SMRequestResponseBlock, responseQueue aResponseQueue: DispatchQueue) -> Self {
        
        responseBlocks.append(SMResponseNode(responseBlock: aResponseBlock, responseQueue: aResponseQueue))
        
        return self
    }

    open func clearAllResponseBlocks() {
        
        responseBlocks.removeAll()
    }
        
    open func executeAllUploadProgressBlocksWith(progress aProgress: Progress) {
        
        for node: SMRequestProgressNode in uploadProgressBlocks {
            
            node.requestQueue.async {
                node.requestProgressBlock(self, aProgress)
            }
        }
    }
    
    open func executeAllDownloadProgressBlocksWith(progress aProgress: Progress) {
        
        for node: SMRequestProgressNode in uploadProgressBlocks {
            
            node.requestQueue.async {
                node.requestProgressBlock(self, aProgress)
            }
        }
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
