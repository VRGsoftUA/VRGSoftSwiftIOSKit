//
//  SMGatewayRequestMultipart.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/6/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit
import Alamofire

public typealias SMConstructingMultipartFormDataBlock = (MultipartFormData) -> Void

open class SMGatewayRequestMultipart: SMGatewayRequest {
    
    open var constructingBlock: SMConstructingMultipartFormDataBlock
    
    public init(gateway aGateway: SMGateway, type aType: HTTPMethod, constructingBlock: @escaping SMConstructingMultipartFormDataBlock) {
        
        self.constructingBlock = constructingBlock
        super.init(gateway: aGateway, type: aType)
    }
    
    public required init(gateway aGateway: SMGateway, type aType: HTTPMethod) {
        
        fatalError("init(gateway:type:) has not been implemented")
    }
    
    override open func getDataRequest() -> UploadRequest? {

        guard let fullPath: URL = fullPath else { return nil }
        
        let dataRequest: UploadRequest = AF.upload(multipartFormData: { multipartFormData in
            self.constructingBlock(multipartFormData)
        },
                                                   to: fullPath,
                                                   method: type,
                                                   headers: allHeaders,
                                                   interceptor: SMGatewayConfigurator.shared.interceptor)

        self.dataRequest = dataRequest

        SMGatewayConfigurator.shared.interceptor.addRetryInfo(gatewayRequest: self)

        dataRequest.responseJSON { [weak self] responseObject in

            guard let self = self else {
                return
            }

            switch responseObject.result {
            case .success:

                SMGatewayConfigurator.shared.interceptor.deleteRetryInfo(gatewayRequest: self)

                let callBack: SMRequestParserBlock = { (aResponse: SMResponse) in
                    if self.executeAllResponseBlocksSync {
                        self.executeSynchronouslyAllResponseBlocks(response: aResponse)
                    } else {
                        self.executeAllResponseBlocks(response: aResponse)
                    }
                }

                if let successParserBlock: SMGatewayRequestSuccessParserBlock = self.successParserBlock,
                   let dataRequest: DataRequest = self.dataRequest {

                    successParserBlock(dataRequest, responseObject, callBack)
                } else {

                    if let dataRequest: DataRequest = self.dataRequest,
                       let response: SMResponse = self.successBlock?(dataRequest, responseObject) {

                        callBack(response)
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                self.executeFailureBlock(responseObject: responseObject)
            }
        }

        return dataRequest
    }
}
