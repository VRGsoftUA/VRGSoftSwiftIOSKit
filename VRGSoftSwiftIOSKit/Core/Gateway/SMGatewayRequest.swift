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

open class SMGatewayRequest: SMRequest
{
    open unowned var gateway: SMGateway
    open var dataRequest: DataRequest?
    
    open var path: String?
    open var type: HTTPMethod
    open var parameterEncoding: ParameterEncoding?
    
    open var parameters: [String: AnyObject] = [:]
    open var headers: [String: String] = [:]
    
    open var successBlock: SMGatewayRequestResponseBlock?
    open var successParserBlock: SMGatewayRequestSuccessParserBlock?
    open var failureBlock: SMGatewayRequestResponseBlock?
    
    public required init(gateway aGateway: SMGateway, type aType: HTTPMethod)
    {
        gateway = aGateway
        self.type = aType
    }
    
    override open func start()
    {
        super.start()
        
        gateway.start(request: self)
    }
    
    override open func cancel()
    {
        dataRequest?.cancel()
    }
    
    override open func canExecute() -> Bool
    {
        return gateway.isInternetReachable()
    }
    
    override open func isCancelled() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    override open func isExecuting() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.running
    }
    
    override open func isFinished() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    open func getDataRequest(completion: @escaping (_ request: DataRequest) -> Void)
    {
        guard let baseUrl: URL = gateway.baseUrl else { return }
        
        var fullPath: URL = baseUrl
        
        if let path: String = path
        {
            fullPath = fullPath.appendingPathComponent(path)
        }
        
        var allParams: [String: Any] = [:]
        
        for (key, value): (String, AnyObject) in (gateway.defaultParameters)
        {
            allParams.updateValue(value, forKey: key)
        }
        
        for (key, value): (String, AnyObject) in (parameters)
        {
            allParams.updateValue(value, forKey: key)
        }
        
        var allHeaders: [String: String] = [:]
        
        for (key, value): (String, String) in (gateway.defaultHeaders)
        {
            allHeaders.updateValue(value, forKey: key)
        }
        
        for (key, value): (String, String) in (headers)
        {
            allHeaders.updateValue(value, forKey: key)
        }
        
        switch type
        {
        case .options, .head, .get, .delete:
            parameterEncoding = URLEncoding.default
        case .patch, .post, .put:
            parameterEncoding = JSONEncoding.default
        default: break
        }
        
        print("\n\nSTART", self)
        print("URL - ", fullPath, "\n", "TYPE - ", type, "\n", "HEADERS - ", allHeaders, "\n", "PARAMS - ", allParams, "\n\n")
        
        if parameterEncoding == nil
        {
            switch type
            {
            case .options, .head, .get, .delete:
                parameterEncoding = URLEncoding.default
            case .patch, .post, .put:
                parameterEncoding = JSONEncoding.default
            default: break
            }
        }
        
        if let parameterEncoding: ParameterEncoding = parameterEncoding
        {
            let dataRequest: DataRequest = Alamofire.request(fullPath, method: type, parameters: allParams, encoding: parameterEncoding, headers: allHeaders)
            self.dataRequest = dataRequest
            
            dataRequest.responseJSON(completionHandler: {[weak self] responseObject in // swiftlint:disable:this explicit_type_interface
                
                switch responseObject.result
                {
                case .success:
                    //                    print("Request success with data: \(data)")
                    let callBack: SMRequestParserBlock = { (aResponse: SMResponse) in
                        if let strongSelf: SMGatewayRequest = self
                        {
                            if strongSelf.executeAllResponseBlocksSync
                            {
                                strongSelf.executeSynchronouslyAllResponseBlocks(response: aResponse)
                            } else
                            {
                                strongSelf.executeAllResponseBlocks(response: aResponse)
                            }
                        }
                    }
                    
                    if let successParserBlock: SMGatewayRequestSuccessParserBlock = self?.successParserBlock
                    {
                        successParserBlock(dataRequest, responseObject, callBack)
                    } else
                    {
                        if let response: SMResponse = self?.successBlock?(dataRequest, responseObject)
                        {
                            callBack(response)
                        }
                    }
                case .failure(let error): // swiftlint:disable:this explicit_type_interface
                    print("Request failed with error: \(error)")
                    self?.executeFailureBlock(responseObject: responseObject)
                }
            })
            
            return completion(dataRequest)
        }
    }
    
    open func executeSuccessBlock(responseObject aResponseObject: DataResponse<Any>)
    {
        if let successBlock: SMGatewayRequestResponseBlock = successBlock,
            let dataRequest: DataRequest = dataRequest
        {
            let response: SMResponse = successBlock(dataRequest, aResponseObject)
            
            if executeAllResponseBlocksSync
            {
                executeSynchronouslyAllResponseBlocks(response: response)
            } else
            {
                executeAllResponseBlocks(response: response)
            }
        }
    }
    
    open func executeFailureBlock(responseObject aResponseObject: DataResponse<Any>)
    {
        if let failureBlock: SMGatewayRequestResponseBlock = failureBlock,
            let dataRequest: DataRequest = dataRequest
        {
            let response: SMResponse = failureBlock(dataRequest, aResponseObject)
            
            if executeAllResponseBlocksSync
            {
                executeSynchronouslyAllResponseBlocks(response: response)
            } else
            {
                executeAllResponseBlocks(response: response)
            }
        }
    }
    
    open func setup(successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock, failureBlock aFailureBlock: @escaping SMGatewayRequestResponseBlock)
    {
        successBlock = aSuccessBlock
        failureBlock = aFailureBlock
    }
    
    open func setup(successParserBlock aSuccessParserBlock: @escaping SMGatewayRequestSuccessParserBlock, failureBlock aFailureBlock: @escaping SMGatewayRequestResponseBlock)
    {
        successParserBlock = aSuccessParserBlock
        failureBlock = aFailureBlock
    }
}
