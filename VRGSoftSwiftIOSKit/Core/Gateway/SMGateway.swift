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
    var defaultParameters: [String: AnyObject] = [:]
    var defaultHeaders: [String: String] = [:]

    var baseUrl: URL?
    var parameterEncoding: ParameterEncoding = JSONEncoding.default
    
    var requests: [SMGatewayRequest] = []
    
    func isInternetReachable() -> Bool
    {
        return SMGatewayConfigurator.shared.isInternetReachable()
    }
    
    func configureWithBase(url aUrl: URL)
    {
        baseUrl = aUrl
    }
    
    func start(request aRequest: SMGatewayRequest)
    {
        aRequest.getDataRequest { request in
            request.resume()
        }
    }
    
    func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestFailureBlock
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
    
    func getRequestClass() -> SMGatewayRequest.Type
    {
        return SMGatewayRequest.self
    }
    
    func request(type aType: HTTPMethod, path aPath: String, parameters aParameters: [String: AnyObject]? = [:], successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock) -> SMGatewayRequest
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
    
    func uploadRequest(type aType: HTTPMethod = .post,
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
