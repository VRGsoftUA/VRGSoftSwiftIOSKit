//
//  SMGatewayRequest.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation
import Alamofire

typealias SMGatewayRequestSuccessBlock = (DataRequest, DataResponse<Any>) -> SMResponse
typealias SMGatewayRequestFailureBlock = (DataRequest, Error?) -> SMResponse

open class SMGatewayRequest: SMRequest
{
    unowned var gateway: SMGateway
    var dataRequest: DataRequest?
    
    var path: String?
    var type: HTTPMethod
    var parameters: [String: AnyObject] = [:]
    var headers: [String: String] = [:]
    
    var successBlock: SMGatewayRequestSuccessBlock?
    var failureBlock: SMGatewayRequestFailureBlock?
    
    public required init(gateway aGateway: SMGateway, type aType: HTTPMethod)
    {
        gateway = aGateway
        type = aType
    }
    
    override func start()
    {
        super.start()
        
        gateway.start(request: self)
    }
    
    override func cancel()
    {
        dataRequest?.cancel()
    }
    
    override func canExecute() -> Bool
    {
        return gateway.isInternetReachable()
    }
    
    override func isCancelled() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    override func isExecuting() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.running
    }
    
    override func isFinished() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    func getDataRequest(completion: @escaping (_ request: DataRequest) -> Void)
    {
        guard let baseUrl = gateway.baseUrl else { return }
        
        var fullPath: URL = baseUrl
        
        if let path = path
        {
            fullPath = fullPath.appendingPathComponent(path)
        }
                
        var allParams: [String: Any] = [:]
        
        for (key, value) in (gateway.defaultParameters)
        {
            allParams.updateValue(value, forKey: key)
        }

        for (key, value) in (parameters)
        {
            allParams.updateValue(value, forKey: key)
        }

        var allHeaders: [String: String] = [:]
        
        for (key, value) in (gateway.defaultHeaders)
        {
            allHeaders.updateValue(value, forKey: key)
        }
        
        for (key, value) in (headers)
        {
            allHeaders.updateValue(value, forKey: key)
        }
        
        print("\n\nSTART", self)
        print("URL - ", fullPath, "\n", "TYPE - ", type, "\n", "HEADERS - ", allHeaders, "\n", "PARAMS - ", allParams, "\n\n")

        let dataRequest = Alamofire.request(fullPath, method: type, parameters: allParams, encoding: gateway.parameterEncoding, headers: allHeaders)
        self.dataRequest = dataRequest
        
        dataRequest.responseJSON(completionHandler: {[weak self] responseObject in
            
            switch responseObject.result
            {
            case .success:
//                    print("Request success with data: \(data)")
                self?.executeSuccessBlock(responseObject: responseObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                self?.executeFailureBlock(responseObject: responseObject)
            }
        })
        
        return completion(dataRequest)
    }
    
    func executeSuccessBlock(responseObject aResponseObject: DataResponse<Any>)
    {
        if let successBlock = successBlock, let dataRequest = dataRequest
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
    
    func executeFailureBlock(responseObject aResponseObject: DataResponse<Any>)
    {
        if let failureBlock = failureBlock, let dataRequest = dataRequest
        {
            let response: SMResponse = failureBlock(dataRequest, aResponseObject.error)
            
            if executeAllResponseBlocksSync
            {
                executeSynchronouslyAllResponseBlocks(response: response)
            } else
            {
                executeAllResponseBlocks(response: response)
            }
        }
    }

    func setup(successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock, failureBlock aFailureBlock: @escaping SMGatewayRequestFailureBlock)
    {
        successBlock = aSuccessBlock
        failureBlock = aFailureBlock
    }
}
