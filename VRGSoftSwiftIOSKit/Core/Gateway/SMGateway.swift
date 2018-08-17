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
    
    open var requests: [SMGatewayRequest] = []
    
    public init()
    {
        
    }
    
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
    
    open func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestResponseBlock
    {
        func result(data: DataRequest, responseObject: DataResponse<Any>) -> SMResponse
        {
            let response: SMResponse = SMResponse()
            response.isSuccess = false
            response.textMessage = responseObject.error?.localizedDescription
            
            return response
        }
        
        return result
    }
    
    
    // MARK: Request Fabric
    
    open func getRequestClass() -> SMGatewayRequest.Type
    {
        return SMGatewayRequest.self
    }
    
    open func request(type aType: HTTPMethod, path aPath: String, parameters aParameters: [String: AnyObject]? = [:], successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock) -> SMGatewayRequest
    {
        let result: SMGatewayRequest = getRequestClass().init(gateway: self, type: aType)
        
        result.path = aPath
        
        if let parameters: [String: AnyObject] = aParameters
        {
            result.parameters = parameters
        }
        
        let failureBlock: SMGatewayRequestResponseBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }

    open func request(type aType: HTTPMethod, path aPath: String, parameters aParameters: [String: AnyObject]? = [:], successBlock aSuccessParserBlock: @escaping SMGatewayRequestSuccessParserBlock) -> SMGatewayRequest
    {
        let result: SMGatewayRequest = getRequestClass().init(gateway: self, type: aType)
        
        result.path = aPath
        
        if let parameters: [String: AnyObject] = aParameters
        {
            result.parameters = parameters
        }
        
        let failureBlock: SMGatewayRequestResponseBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successParserBlock: aSuccessParserBlock, failureBlock: failureBlock)
        
        return result
    }

    open func uploadRequest(type aType: HTTPMethod = .post, path aPath: String, constructingBlock: @escaping SMConstructingMultipartFormDataBlock, successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock) -> SMGatewayRequestMultipart
    {
        let result: SMGatewayRequestMultipart = SMGatewayRequestMultipart(gateway: self, type: aType, constructingBlock: constructingBlock)
        result.path = aPath
        
        let failureBlock: SMGatewayRequestResponseBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }
}
