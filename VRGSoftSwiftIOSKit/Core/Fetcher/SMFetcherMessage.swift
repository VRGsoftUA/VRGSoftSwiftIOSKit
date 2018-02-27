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
    let defaultParameters: [String: AnyObject] = [:]
    
    required public init()
    {
    }
}


open class SMFetcherMessagePaging: SMFetcherMessage
{
    var pagingSize: Int = 0
    var pagingOffset: Int = 0
    
    var isReloading: Bool = false
    var isLoadingMore: Bool = false
}
