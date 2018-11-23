//
//  SMNativeActivityAdapter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/8/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMNativeActivityAdapter: SMActivityAdapter
{
    public let backgroundView: UIView = UIView()
    public var activity: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override open func configureWith(view aView: UIView)
    {
        backgroundView.removeFromSuperview()
        activity.removeFromSuperview()
        aView.addSubview(backgroundView)
        
        activity.hidesWhenStopped = true
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.03)
        backgroundView.frame = aView.bounds
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.addSubview(activity)
        activity.center = CGPoint(x: backgroundView.width/2.0, y: backgroundView.height/2.0)
        activity.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.hide()
    }
    
    override open func show()
    {
        backgroundView.superview?.bringSubviewToFront(backgroundView)
        backgroundView.sm_showAnimate(false)
        activity.startAnimating()
    }
    
    override open func hide()
    {
        backgroundView.sm_hideAnimate(false)
        activity.stopAnimating()
    }
}
