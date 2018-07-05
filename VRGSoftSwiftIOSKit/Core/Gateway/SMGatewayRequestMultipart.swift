//
//  SMGatewayRequestMultipart.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/6/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit
import Alamofire

typealias SMConstructingMultipartFormDataBlock = (MultipartFormData) -> Void

class SMGatewayRequestMultipart: SMGatewayRequest
{
    var constructingBlock: SMConstructingMultipartFormDataBlock
    
    public init(gateway aGateway: SMGateway, type aType: HTTPMethod, constructingBlock: @escaping SMConstructingMultipartFormDataBlock)
    {
        self.constructingBlock = constructingBlock
        super.init(gateway: aGateway, type: aType)
    }
    
    public required init(gateway aGateway: SMGateway, type aType: HTTPMethod) {
        fatalError("init(gateway:type:) has not been implemented")
    }
    
    override func getDataRequest(completion: @escaping (_ request: UploadRequest) -> Void)
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
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            self.constructingBlock(multipartFormData)
        }, to: fullPath, method: type, headers: allHeaders, encodingCompletion: { multipartFormDataEncodingResult in
            switch multipartFormDataEncodingResult
            {
            case .success(let request, _, _):
                self.dataRequest = request
                completion(request)
                self.dataRequest?.responseJSON(completionHandler: {[weak self] responseObject in
                    switch responseObject.result
                    {
                    case .success:
//                        print("Request success with data: \(data)")
                        self?.executeSuccessBlock(responseObject: responseObject)
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        self?.executeFailureBlock(responseObject: responseObject)
                    }
                })
            case .failure(let error):
                print(error)
            }
        })
    }
}
