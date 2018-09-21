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
    public static var shared: SMGatewayConfigurator = SMGatewayConfigurator()

    open var gateways: [SMGateway] = []
    open var networkReachabilityManager: NetworkReachabilityManager?
    
    open func isInternetReachable() -> Bool
    {
        let result: Bool = networkReachabilityManager?.isReachable ?? false
        return result
    }
    
    open func register(gateway aGateway: SMGateway)
    {
        gateways.append(aGateway)
    }
    
    open func configureGatewaysWithBase(url aUrl: URL)
    {
        if let host: String = aUrl.host
        {
            networkReachabilityManager = NetworkReachabilityManager(host: host)
            networkReachabilityManager?.startListening()
        } else
        {
            assert(false)
        }
        
        for g: SMGateway in gateways
        {
            g.configureWithBase(url: aUrl)
        }
    }

    open func setHTTPHeader(value aValue: String?, key aKey: String)
    {
        for g: SMGateway in gateways
        {
            g.defaultHeaders[aKey] = aValue
        }
    }
}
