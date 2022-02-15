//
//  SMGatewayConfigurator.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation
import Alamofire

open class SMGatewayConfigurator {
    
    private var defaultParameters: [String: AnyObject] = [:]
    private var defaultHeaders: [String: String] = [:]
    
    public static var shared: SMGatewayConfigurator = SMGatewayConfigurator()
    
    open var url: URL? {
        
        didSet {
            
            if let url: URL = url {
                
                configureGatewaysWithBase(url: url)
            }
        }
    }

    open var interceptor: SMRequestInterceptor = SMRequestInterceptor()
    
    open var gateways: [SMGateway] = []
    open var networkReachabilityManager: NetworkReachabilityManager?

    open func isInternetReachable() -> Bool {
        
        let result: Bool = networkReachabilityManager?.isReachable ?? false
        
        return result
    }
    
    open func register(gateway aGateway: SMGateway) {
        
        defaultHeaders.forEach { (aKey, aValue) in
            
            aGateway.defaultHeaders[aKey] = aValue
        }
        
        defaultParameters.forEach { (aKey, aValue) in
            
            aGateway.defaultParameters[aKey] = aValue
        }
        
        gateways.append(aGateway)
    }
    
    private func configureGatewaysWithBase(url aUrl: URL) {
        
        if let host: String = aUrl.host {
            
            networkReachabilityManager = NetworkReachabilityManager(host: host)
            networkReachabilityManager?.startListening(onUpdatePerforming: { _ in })
        } else {
            
            assert(false)
        }
        
        for g: SMGateway in gateways where g.baseUrl != aUrl {
            
            g.configureWithBase(url: aUrl)
        }
    }
    
    open func setHTTPHeader(value aValue: String?, key aKey: String) {
        
        defaultHeaders[aKey] = aValue
        
        for g: SMGateway in gateways {
            
            g.defaultHeaders[aKey] = aValue
        }
    }
    
    open func setDefaulParameter(value aValue: AnyObject?, key aKey: String) {
        
        defaultParameters[aKey] = aValue
        
        for g: SMGateway in gateways {
            
            g.defaultParameters[aKey] = aValue
        }
    }
}
