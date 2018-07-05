//
//  SMNativePullToRefreshAdapterRefreshCallback.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMNativePullToRefreshAdapter: SMPullToRefreshAdapter
{
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override open var enabled: Bool?
    {
        set {
            refreshControl.isEnabled = (newValue != nil)
            
        }
        get {
            return refreshControl.isEnabled
            
        }
    }
    
    override init()
    {
        super.init()
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidBeginRefreshing(sender:)), for: UIControlEvents.valueChanged)
    }
    
    override open func configureWith(scrollView aScrollView: UIScrollView)
    {
        aScrollView.addSubview(refreshControl)
        aScrollView.sendSubview(toBack: refreshControl)
    }
    
    override open func beginPullToRefresh()
    {
        refreshControl.beginRefreshing()
        super.beginPullToRefresh()
    }
    
    override open func endPullToRefresh()
    {
        refreshControl.endRefreshing()
    }
    
    @objc func refreshControlDidBeginRefreshing(sender aSender: UIRefreshControl)
    {
        if refreshControl == aSender
        {
            self.beginPullToRefresh()
        }
    }
}
