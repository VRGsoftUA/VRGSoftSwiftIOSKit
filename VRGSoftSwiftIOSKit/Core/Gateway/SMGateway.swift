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
    
    func configureWithBase(url aUrl: URL) -> Void
    {
        baseUrl = aUrl
    }
    
    func start(request aRequest: SMGatewayRequest) -> Void
    {
        aRequest.getDataRequest().resume()
    }
    
    func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestFailureBlock
    {
        func result(data: DataRequest,error: Error) -> SMResponse
        {
            let response: SMResponse = SMResponse()
            response.isSuccess = false
            response.textMessage = error.localizedDescription
            
            return response
        }

        return result
    }
    
    
    // MARK: Request Fabric
    
    func request(type aType: HTTPMethod, path aPath: String,parameters aParameters: [String: AnyObject], successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock) -> SMGatewayRequest
    {
        let result: SMGatewayRequest = SMGatewayRequest(gateway: self, type: aType)
        
        result.path = aPath
        result.parameters = aParameters
        
        let failureBlock: SMGatewayRequestFailureBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }
}
