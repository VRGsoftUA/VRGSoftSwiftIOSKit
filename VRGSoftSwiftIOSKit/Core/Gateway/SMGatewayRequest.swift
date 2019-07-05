//
//  SMGatewayRequest.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation
import Alamofire

public typealias SMGatewayRequestResponseBlock = (DataRequest, DataResponse<Any>) -> SMResponse

public typealias SMRequestParserBlock = (SMResponse) -> Void
public typealias SMGatewayRequestSuccessParserBlock = (DataRequest, DataResponse<Any>, @escaping SMRequestParserBlock) -> Void

open class SMGatewayRequest: SMRequest {
    
    public var debugDescription: String {
        
        var array: [String] = []
        
        array.append("URL - " + (dataRequest?.request?.url?.absoluteString ?? (fullPath?.absoluteString) ?? ""))
        array.append("TYPE - " + type.rawValue)
        array.append("HEADERS - " + allHeaders.description)
        array.append("PARAMS - " + allParams.description)
        
        return  array.joined(separator: "\n")
    }
    
    open unowned var gateway: SMGateway
    open var dataRequest: DataRequest?
    
    open var retryCount: Int = 4
    open var retryTime: TimeInterval = 0.5
    
    open var path: String?
    open var type: HTTPMethod
    open var parameterEncoding: ParameterEncoding?
    
    open var parameters: [String: AnyObject] = [:]
    open var headers: [String: String] = [:]
    
    open var successBlock: SMGatewayRequestResponseBlock?
    open var successParserBlock: SMGatewayRequestSuccessParserBlock?
    open var failureBlock: SMGatewayRequestResponseBlock?
    
    var allParams: [String: Any] {
        
        var result: [String: Any] = [:]
        
        for (key, value): (String, AnyObject) in (gateway.defaultParameters) {
            
            result.updateValue(value, forKey: key)
        }
        
        for (key, value): (String, AnyObject) in (parameters) {
            
            result.updateValue(value, forKey: key)
        }
        
        return result
    }
    
    var allHeaders: [String: String] {
        
        var result: [String: String] = [:]
        
        for (key, value): (String, String) in (gateway.defaultHeaders) {
            
            result.updateValue(value, forKey: key)
        }
        
        for (key, value): (String, String) in (headers) {
            
            result.updateValue(value, forKey: key)
        }
        
        return result
    }
    
    var fullPath: URL? {
        
        var result: URL? = gateway.baseUrl
        
        if let path: String = path {
            
            result = result?.appendingPathComponent(path)
        }
        
        return result
    }
    
    
    public required init(gateway aGateway: SMGateway, type aType: HTTPMethod) {
        
        gateway = aGateway
        self.type = aType
    }
    
    override open func start() {
        
        super.start()
        
        gateway.start(request: self)
    }
    
    override open func cancel() {
        
        dataRequest?.cancel()
    }
    
    override open func canExecute() -> Bool {
        
        return gateway.isInternetReachable()
    }
    
    override open func isCancelled() -> Bool {
        
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    override open func isExecuting() -> Bool {
        
        return dataRequest?.task?.state == URLSessionTask.State.running
    }
    
    override open func isFinished() -> Bool {
        
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    open func getDataRequest(completion: @escaping (_ request: DataRequest) -> Void) {
        
        guard let baseUrl: URL = gateway.baseUrl else { return }
        
        var fullPath: URL = baseUrl
        
        if let path: String = path {
            
            fullPath = fullPath.appendingPathComponent(path)
        }
                
        if parameterEncoding == nil {
            
            switch type {
            case .options, .head, .get, .delete:
                parameterEncoding = URLEncoding.default
            case .patch, .post, .put:
                parameterEncoding = JSONEncoding.default
            default: break
            }
        }
        
        if let parameterEncoding: ParameterEncoding = parameterEncoding {
            
            let dataRequest: DataRequest = Alamofire.request(fullPath, method: type, parameters: allParams, encoding: parameterEncoding, headers: allHeaders)
            self.dataRequest = dataRequest
            
            print("\n\nSTART", self)
            print(debugDescription)
            
            SMGatewayConfigurator.shared.retrier.addRetryInfo(gatewayRequest: self)
            
            dataRequest.responseJSON(completionHandler: {[weak self] responseObject in
                
                switch responseObject.result {
                case .success:
                    
                    if let strongSelf: SMGatewayRequest = self {
                        SMGatewayConfigurator.shared.retrier.deleteRetryInfo(gatewayRequest: strongSelf)
                    }
                    
                    //                    print("Request success with data: \(data)")
                    let callBack: SMRequestParserBlock = { (aResponse: SMResponse) in
                        if let strongSelf: SMGatewayRequest = self {
                            
                            if strongSelf.executeAllResponseBlocksSync {
                                strongSelf.executeSynchronouslyAllResponseBlocks(response: aResponse)
                            } else {
                                strongSelf.executeAllResponseBlocks(response: aResponse)
                            }
                        }
                    }
                    
                    if let successParserBlock: SMGatewayRequestSuccessParserBlock = self?.successParserBlock {
                        
                        successParserBlock(dataRequest, responseObject, callBack)
                    } else {
                        if let response: SMResponse = self?.successBlock?(dataRequest, responseObject) {
                            
                            callBack(response)
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self?.executeFailureBlock(responseObject: responseObject)
                }
            })
            
            return completion(dataRequest)
        }
    }
    
    open func executeSuccessBlock(responseObject aResponseObject: DataResponse<Any>) {
        
        if let successBlock: SMGatewayRequestResponseBlock = successBlock,
            let dataRequest: DataRequest = dataRequest {
            
            let response: SMResponse = successBlock(dataRequest, aResponseObject)
            
            if executeAllResponseBlocksSync {
                
                executeSynchronouslyAllResponseBlocks(response: response)
            } else {
                
                executeAllResponseBlocks(response: response)
            }
        }
    }
    
    open func executeFailureBlock(responseObject aResponseObject: DataResponse<Any>) {
        
        if let failureBlock: SMGatewayRequestResponseBlock = failureBlock,
            let dataRequest: DataRequest = dataRequest {
            
            let response: SMResponse = failureBlock(dataRequest, aResponseObject)
            
            if executeAllResponseBlocksSync {
                
                executeSynchronouslyAllResponseBlocks(response: response)
            } else {
                
                executeAllResponseBlocks(response: response)
            }
        }
    }
    
    open func setup(successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock, failureBlock aFailureBlock: @escaping SMGatewayRequestResponseBlock) {
        
        successBlock = aSuccessBlock
        failureBlock = aFailureBlock
    }
    
    open func setup(successParserBlock aSuccessParserBlock: @escaping SMGatewayRequestSuccessParserBlock, failureBlock aFailureBlock: @escaping SMGatewayRequestResponseBlock) {
        
        successParserBlock = aSuccessParserBlock
        failureBlock = aFailureBlock
    }
}
