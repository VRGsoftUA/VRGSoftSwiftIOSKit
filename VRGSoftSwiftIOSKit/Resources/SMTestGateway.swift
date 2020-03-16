//
//  SMTestGateway.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/4/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import VRGSoftIOSNetworkKit
import Alamofire

class SMTestGateway: SMGateway {

    static let shared: SMTestGateway = SMTestGateway()
    
    override func acceptableStatusCodes() -> [Int]? {
        return []
    }
    
    func getTestData() -> SMGatewayRequest {
        return request(type: .get, path: "get", parameters: nil) { _, _ -> SMResponse in
            
            return SMResponse()
        }
    }
    
    open override func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestResponseBlock {
        
        func result(data: DataRequest, responseObject: DataResponse<Any>) -> SMResponse {
            
            let response: SMResponse = SMResponse()
            
            response.isCancelled = (responseObject.error as NSError?)?.code == NSURLErrorCancelled
            response.isSuccess = false
            response.textMessage = responseObject.error?.localizedDescription
            response.error = responseObject.error
            
            return response
        }
        
        return result
    }
}
