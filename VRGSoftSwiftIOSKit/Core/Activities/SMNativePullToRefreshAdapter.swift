//
//  SMNativePullToRefreshAdapterRefreshCallback.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMNativePullToRefreshAdapter: SMPullToRefreshAdapter {
    
    public lazy var refreshControl: UIRefreshControl = {
        return createRefreshControl()
    }()
    
    public func createRefreshControl() -> UIRefreshControl {
        return UIRefreshControl()
    }
    
    override open var enabled: Bool? {
        
        set {
            refreshControl.isEnabled = (newValue != nil)
            
        }
        get {
            return refreshControl.isEnabled
            
        }
    }
    
    override public init() {
        
        super.init()
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidBeginRefreshing(sender:)), for: UIControl.Event.valueChanged)
    }
    
    override open func configureWith(scrollView aScrollView: UIScrollView) {
        
        if #available(iOS 10.0, *) {
            
            aScrollView.refreshControl = refreshControl
        } else {
            
            aScrollView.addSubview(refreshControl)
            aScrollView.sendSubviewToBack(refreshControl)
        }
    }
    
    override open func beginPullToRefresh() {
        
        refreshControl.beginRefreshing()
        super.beginPullToRefresh()
    }
    
    override open func endPullToRefresh() {
        
        refreshControl.endRefreshing()
    }
    
    @objc open func refreshControlDidBeginRefreshing(sender aSender: UIRefreshControl) {
        
        if refreshControl == aSender {
            
            self.beginPullToRefresh()
        }
    }
}
