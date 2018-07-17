//
//  SMGateway.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation
import Alamofire

open class SMGateway
{
    open var defaultParameters: [String: AnyObject] = [:]
    open var defaultHeaders: [String: String] = [:]

    open var baseUrl: URL?
    open var parameterEncoding: ParameterEncoding = JSONEncoding.default
    
    open var requests: [SMGatewayRequest] = []
    
    open func isInternetReachable() -> Bool
    {
        return SMGatewayConfigurator.shared.isInternetReachable()
    }
    
    open func configureWithBase(url aUrl: URL)
    {
        baseUrl = aUrl
    }
    
    open func start(request aRequest: SMGatewayRequest)
    {
        aRequest.getDataRequest { request in
            request.resume()
        }
    }
    
    open func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestFailureBlock
    {
        func result(data: DataRequest, error: Error?) -> SMResponse
        {
            let response: SMResponse = SMResponse()
            response.isSuccess = false
            response.textMessage = error?.localizedDescription
            
            return response
        }

        return result
    }
    
    
    // MARK: Request Fabric
    
    open func getRequestClass() -> SMGatewayRequest.Type
    {
        return SMGatewayRequest.self
    }
    
    open func request(type aType: HTTPMethod, path aPath: String, parameters aParameters: [String: AnyObject]? = [:], successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock) -> SMGatewayRequest
    {
        let result: SMGatewayRequest = getRequestClass().init(gateway: self, type: aType)
        
        result.path = aPath
        
        if let parameters = aParameters
        {
            result.parameters = parameters
        }
        
        let failureBlock: SMGatewayRequestFailureBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }
    
    open func uploadRequest(type aType: HTTPMethod = .post,
                       path aPath: String,
                       constructingBlock: @escaping SMConstructingMultipartFormDataBlock,
                       successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock) -> SMGatewayRequestMultipart
    {
        let result: SMGatewayRequestMultipart = SMGatewayRequestMultipart(gateway: self, type: aType, constructingBlock: constructingBlock)
        result.path = aPath
        
        let failureBlock: SMGatewayRequestFailureBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }
}
