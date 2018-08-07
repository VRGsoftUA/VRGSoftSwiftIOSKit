//
//  SMPullToRefreshAdapter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMPullToRefreshAdapterRefreshCallback = (SMPullToRefreshAdapter) -> Void

open class SMPullToRefreshAdapter
{
    open var enabled: Bool?
    
    public var refreshCallback: SMPullToRefreshAdapterRefreshCallback?
    
    open func configureWith(scrollView aScrollView: UIScrollView)
    {
        
    }
    
    open func beginPullToRefresh()
    {
        self.refreshCallback?(self)
    }

    open func endPullToRefresh()
    {
        
    }
}
