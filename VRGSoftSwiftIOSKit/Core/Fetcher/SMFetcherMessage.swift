//
//  SMFetcherMessage.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMFetcherMessage: NSObject
{
    let defaultParameters: [String: AnyObject] = [:]
    
    required override init()
    {
        super.init()
    }
}


open class SMFetcherMessagePaging: SMFetcherMessage
{
    var pagingSize: Int = 0
    var pagingOffset: Int = 0
    
    var isReloading: Bool = false
    var isLoadingMore: Bool = false
}
