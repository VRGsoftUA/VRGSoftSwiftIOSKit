//
//  SMTestGateway.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 6/4/19.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Alamofire

class SMTestGateway: SMGateway {

    static let shared: SMTestGateway = SMTestGateway()
    
    func getTestData() -> SMGatewayRequest {
        let req: SMGatewayRequest = request(type: .get, path: "get", parameters: nil) { _, _ -> SMResponse in
            
            return SMResponse()
        }
        req.retryCount = 2
        return req
    }
    
    open override func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestResponseBlock {
        
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
}
