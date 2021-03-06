//
//  SMDataFetcherProtocol.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public typealias SMDataFetchCallback = (SMResponse) -> Void


public protocol SMDataFetcherProtocol {
    
    var callbackQueue: DispatchQueue {get set}
    
    func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
    func cancelFetching()
}
