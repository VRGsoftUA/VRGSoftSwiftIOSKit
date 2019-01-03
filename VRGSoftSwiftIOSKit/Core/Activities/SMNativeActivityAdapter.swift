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
    public weak var parentView: UIView?
    
    public lazy var activity: UIActivityIndicatorView = {
        return createActivityIndicatorView()
    }()
    
    public lazy var backgroundView: UIView = {
        return createBackgroundView()
    }()
    
    public var backgroundViewColor: UIColor = UIColor.black.withAlphaComponent(0.03)
    {
        didSet
        {
            backgroundView.backgroundColor = backgroundViewColor
        }
    }
    
    public func createActivityIndicatorView() -> UIActivityIndicatorView
    {
        let activity: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
        activity.hidesWhenStopped = true
        return activity
    }
    
    public func createBackgroundView() -> UIView
    {
        return UIView()
    }
    
    override open func configureWith(view aView: UIView)
    {
        parentView = aView
        
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = backgroundViewColor
        
        activity.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    }
    
    override open func show()
    {
        guard let parentView: UIView = parentView else { return }
        
        hide()
        
        backgroundView.frame = parentView.bounds
        parentView.addSubview(backgroundView)
        
        activity.center = CGPoint(x: backgroundView.width/2.0, y: backgroundView.height/2.0)
        backgroundView.addSubview(activity)
        
        backgroundView.superview?.bringSubviewToFront(backgroundView)
        
        activity.startAnimating()
    }
    
    override open func hide()
    {
        activity.stopAnimating()
        
        backgroundView.removeFromSuperview()
        activity.removeFromSuperview()
    }
}
