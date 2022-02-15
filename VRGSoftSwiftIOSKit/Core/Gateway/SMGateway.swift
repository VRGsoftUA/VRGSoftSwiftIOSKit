//
//  SMGateway.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation
import Alamofire

open class SMGateway {
    
    open var defaultParameters: [String: AnyObject] = [:]
    open var defaultHeaders: [String: String] = [:]
    
    open var baseUrl: URL?
    
    open var requests: [SMGatewayRequest] = []
    
    public init() {
        
        defaultGatewayConfigurator().register(gateway: self)
        
        if let url: URL = defaultGatewayConfigurator().url {
            
            configureWithBase(url: url)
        }
    }
    
    open func isInternetReachable() -> Bool {
        
        return SMGatewayConfigurator.shared.isInternetReachable()
    }
    
    open func configureWithBase(url aUrl: URL) {
        
        baseUrl = aUrl
    }
    
    open func acceptableStatusCodes() -> [Int]? {
        return Array(200..<300)
    }
    
    open func acceptableContentTypes(for dataRequest: DataRequest) -> [String]? {
        
        if let accept: String = dataRequest.request?.value(forHTTPHeaderField: "Accept") {
            
            return accept.components(separatedBy: ",")
        }
        
        return ["*/*"]
    }
    
    open func start(request aRequest: SMGatewayRequest) {
        guard let request = aRequest.getDataRequest() else {
            return
        }
        
        if let acceptableStatusCodes: [Int] = acceptableStatusCodes() {
            request.validate(statusCode: acceptableStatusCodes)
        }

        if let acceptableContentTypes: [String] = acceptableContentTypes(for: request) {
            request.validate(contentType: acceptableContentTypes)
        }

        request.resume()
    }
    
    open func defaultGatewayConfigurator() -> SMGatewayConfigurator {
        
        return SMGatewayConfigurator.shared
    }
    
    open func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestResponseBlock {
        
        func result(data: DataRequest, responseObject: DataResponse<Any, AFError>) -> SMResponse {
            
            let response: SMResponse = SMResponse()

            response.isCancelled = responseObject.error?.isExplicitlyCancelledError == true
            response.isSuccess = false
            response.textMessage = responseObject.error?.localizedDescription
            response.error = responseObject.error
            
            return response
        }
        
        return result
    }
    
    
    // MARK: Request Fabric
    
    open func getRequestClass() -> SMGatewayRequest.Type {
        
        return SMGatewayRequest.self
    }
    
    open func request(type aType: HTTPMethod, path aPath: String, parameters aParameters: [String: AnyObject]? = [:], successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock) -> SMGatewayRequest {
        
        let result: SMGatewayRequest = getRequestClass().init(gateway: self, type: aType)
        
        result.path = aPath
        
        if let parameters: [String: AnyObject] = aParameters {
            
            result.parameters = parameters
        }
        
        let failureBlock: SMGatewayRequestResponseBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }

    open func request(type aType: HTTPMethod, path aPath: String, parameters aParameters: [String: AnyObject]? = [:], successParserBlock aSuccessParserBlock: @escaping SMGatewayRequestSuccessParserBlock) -> SMGatewayRequest {
        
        let result: SMGatewayRequest = getRequestClass().init(gateway: self, type: aType)
        
        result.path = aPath
        
        if let parameters: [String: AnyObject] = aParameters {
            
            result.parameters = parameters
        }
        
        let failureBlock: SMGatewayRequestResponseBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successParserBlock: aSuccessParserBlock, failureBlock: failureBlock)
        
        return result
    }

    open func uploadRequest(type aType: HTTPMethod = .post, path aPath: String, constructingBlock: @escaping SMConstructingMultipartFormDataBlock, successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock) -> SMGatewayRequestMultipart {
        
        let result: SMGatewayRequestMultipart = SMGatewayRequestMultipart(gateway: self, type: aType, constructingBlock: constructingBlock)
        result.path = aPath
        
        let failureBlock: SMGatewayRequestResponseBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }
}
