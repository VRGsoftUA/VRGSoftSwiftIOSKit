//
//  SMRequestInterceptor.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/4/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Alamofire

public typealias RequestRetryCountAndRetryTime = (SMGatewayRequest, Int, TimeInterval)

open class SMRequestInterceptor: RequestInterceptor {
    
    open var requestsRetryCountsAndRetryTime: [RequestRetryCountAndRetryTime] = []
    open var lock: NSLock = NSLock()

    public init() { }

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

    open func retry(request: SMGatewayRequest, retryCount: Int, retryTime: TimeInterval, error: Error, completion: @escaping (RetryResult) -> Void) -> (SMGatewayRequest, Int, TimeInterval) {

        if retryCount == 0 || (error as? AFError)?.isExplicitlyCancelledError == true {

            completion(.doNotRetry)
            return (request, retryCount, retryTime)
        } else {

            completion(.retryWithDelay(retryTime))
            request.printStart(isRetry: true)
            return (request, retryCount - 1, retryTime)
        }
    }

    open func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }

    open func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }

    open func retry(_ request: Request,
                    for session: Session,
                    dueTo error: Error,
                    completion: @escaping (RetryResult) -> Void) {
        
        lock.lock()
        defer { lock.unlock() }
        
        guard let index = index(request: request) else {
            
            completion(.doNotRetry)
            return
        }
        
        let requestRetryCountsAndRetryTime: RequestRetryCountAndRetryTime = requestsRetryCountsAndRetryTime[index]

        requestsRetryCountsAndRetryTime[index] = retry(request: requestRetryCountsAndRetryTime.0,
                                                       retryCount: requestRetryCountsAndRetryTime.1,
                                                       retryTime: requestRetryCountsAndRetryTime.2,
                                                       error: error,
                                                       completion: completion)
    }
}
