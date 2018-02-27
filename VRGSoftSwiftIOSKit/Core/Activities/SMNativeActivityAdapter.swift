//
//  SMNativeActivityAdapter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 2/8/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class SMNativeActivityAdapter: SMActivityAdapter
{
    let backgroundView: UIView = UIView()
    let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func configureWith(view aView: UIView) -> Void
    {
        backgroundView.removeFromSuperview()
        activity.removeFromSuperview()
        aView.addSubview(backgroundView)
        
        activity.hidesWhenStopped = true
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundView.frame = aView.bounds
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.addSubview(activity)
        activity.center = CGPoint(x: backgroundView.width/2.0, y: backgroundView.height/2.0)
        activity.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.hide()
    }
    
    override func show()
    {
        backgroundView.superview?.bringSubview(toFront: backgroundView)
        backgroundView.sm_showAnimate(true)
        activity.startAnimating()
    }
    
    override func hide()
    {
        backgroundView.sm_hideAnimate(true)
        activity.stopAnimating()
    }
}
