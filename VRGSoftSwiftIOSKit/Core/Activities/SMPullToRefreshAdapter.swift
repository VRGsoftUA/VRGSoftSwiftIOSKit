//
//  SMPullToRefreshAdapter.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

typealias SMPullToRefreshAdapterRefreshCallback = (SMPullToRefreshAdapter) -> Void

class SMPullToRefreshAdapter
{
    open var enabled: Bool?
    
    var refreshCallback: SMPullToRefreshAdapterRefreshCallback? = nil
    
    open func configureWith(scrollView aScrollView: UIScrollView) -> Void
    {
        
    }
    
    open func beginPullToRefresh() -> Void
    {
        self.refreshCallback!(self)
    }

    open func endPullToRefresh() -> Void
    {
        
    }
}
