//
//  SMRequestRetrier.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/4/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Alamofire

open class SMRequestRetrier: RequestRetrier {
    
    open var requestsRetryCountsAndRetryTime: [(SMGatewayRequest, Int, TimeInterval)] = []
    open var lock: NSLock = NSLock()
    
    private func index(request: Request?) -> Int? {
        return requestsRetryCountsAndRetryTime.firstIndex(where: { $0.0.dataRequest === request })
    }
    
    open func addRetryInfo(gatewayRequest: SMGatewayRequest) {
        
        lock.lock()
        defer { lock.unlock() }
        
        guard index(request: gatewayRequest.dataRequest) == nil else {
            return
        }
        
        requestsRetryCountsAndRetryTime.append((gatewayRequest, gatewayRequest.retryCount, gatewayRequest.retryTime))
    }
    
    open func deleteRetryInfo(gatewayRequest: SMGatewayRequest) {
        
        lock.lock()
        defer { lock.unlock() }
        
        guard let index = index(request: gatewayRequest.dataRequest) else {
            
            return
        }
        
        requestsRetryCountsAndRetryTime.remove(at: index)
    }
    
    open func should(_ manager: SessionManager,
                     retry request: Request,
                     with error: Error,
                     completion: @escaping RequestRetryCompletion) {
        
        lock.lock()
        defer { lock.unlock() }
        
        guard let index = index(request: request) else {
            
            completion(false, 0)
            return
        }
        
        let (request, retryCount, retryTime): (SMGatewayRequest, Int, TimeInterval) = requestsRetryCountsAndRetryTime[index]
        
        if retryCount == 0 || (error as NSError?)?.code == NSURLErrorCancelled {
            
            completion(false, 0)
            
        } else {
            
            requestsRetryCountsAndRetryTime[index] = (request, retryCount - 1, retryTime)
            completion(true, retryTime)
            print("\n\nRETRY", request)
            print(request.debugDescription)
        }
    }
}
