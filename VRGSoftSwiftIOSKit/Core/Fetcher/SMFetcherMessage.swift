//
//  SMFetcherMessage.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMFetcherMessage
{
    open var defaultParameters: [String: Any] = [:]
    
    required public init()
    {
    }
}


open class SMFetcherMessagePaging: SMFetcherMessage
{
    open var pagingSize: Int = 0
    open var pagingOffset: Int = 0
    
    open var isReloading: Bool = false
    open var isLoadingMore: Bool = false
}
