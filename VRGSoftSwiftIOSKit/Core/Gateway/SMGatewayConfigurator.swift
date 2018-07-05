//
//  SMGatewayConfigurator.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation
import Alamofire

open class SMGatewayConfigurator
{
    static var shared: SMGatewayConfigurator = SMGatewayConfigurator()

    var gateways: [SMGateway] = []
    var networkReachabilityManager: NetworkReachabilityManager?
    
    func isInternetReachable() -> Bool
    {
        let result: Bool = networkReachabilityManager?.isReachable ?? false
        return result
    }
    
    func register(gateway aGateway: SMGateway)
    {
        gateways.append(aGateway)
    }
    
    func configureGatewaysWithBase(url aUrl: URL)
    {
        if let host = aUrl.host
        {
            networkReachabilityManager = NetworkReachabilityManager(host: host)
            networkReachabilityManager?.startListening()
        } else
        {
            assert(false)
        }
        
        for g in gateways
        {
            g.configureWithBase(url: aUrl)
        }
    }

    func setHTTPHeader(value aValue: String?, key aKey: String)
    {
        for g in gateways
        {
            g.defaultHeaders[aKey] = aValue
        }
    }
}
