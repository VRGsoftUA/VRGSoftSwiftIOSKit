//
//  SMPopupViewController.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

class SMPopupViewController: UIViewController
{
    static let motionDuration = 0.4
    
    let overlayViewAlpha = 0.3
    var overlayView: UIView! = UIView()
    var popupedViewOwner: UIView! = UIView()
    var popupedView: SMPopupView = SMPopupView()
    var btHidden: UIButton! = UIButton(type: UIButtonType.custom)
    var isShow: Bool = false
    var isAnimatingNow: Bool = false
    
    
    //MARK: View lifecycle
    func setupSubviews()
    {
        var frame = self.view.bounds
        frame.origin.y = self.view.bounds.size.height
        popupedViewOwner.frame = frame
        self.view.addSubview(popupedViewOwner)
        popupedViewOwner.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // btHidden
        popupedViewOwner.addSubview(btHidden)
        btHidden.frame = self.view.bounds
        btHidden.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        btHidden.addTarget(self, action: #selector(hidedButtonPressed(sender:)), for: .touchUpInside)
        btHidden.isHidden = popupedView.isHideByTapOutside
        
        if popupedView.isShowOverlayView
        {
            overlayView.frame = self.view.bounds
            self.view.addSubview(overlayView)
            overlayView.backgroundColor = .gray
            overlayView.alpha = 0.0
            overlayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.view.sendSubview(toBack: overlayView)
        }
        
        // popuped view
        popupedViewOwner.addSubview(popupedView)
        frame = popupedView.frame
        frame.origin.y = self.view.bounds.size.height - frame.size.height
        frame.size.width = popupedViewOwner.bounds.size.width
        popupedView.frame = frame
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.isHidden = true
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.backgroundColor = .clear
    }
    
    func popupWillAppear(animated: Bool)
    {
        if self.view.superview != nil
        {
            self.view.frame = self.view.superview!.bounds
            self.setupSubviews()
            self.view.superview!.bringSubview(toFront: self.view)
            self.view.isHidden = false
            popupedView.popupWillAppear(animated: animated)
        }
    }
    
    func popupDidAppear(animated: Bool)
    {
        popupedView.popupDidAppear(animated: animated)
    }
    
    func popupWillDisappear(animated: Bool)
    {
        popupedView.popupWillDisappear(animated: animated)
    }
    
    func popupDidDisappear(animated: Bool)
    {
        isShow = false
        self.view.removeFromSuperview()
        popupedView.popupDidDisappear(animated: animated)
    }
    
    
    //MARK: Rotations
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    
    //MARK: Show/Hide
    
    func show(animated: Bool, inView aView: UIView)
    {
        if isShow || isAnimatingNow { return }
        
        aView.addSubview(view)
        self.popupWillAppear(animated: animated)
        
        //animation
        isShow = true
        
        if animated
        {
            //animations
            UIView.animate(withDuration: SMPopupViewController.motionDuration, animations: { 
                self.isAnimatingNow = true
                
                //motion
                var frame = self.popupedViewOwner.frame
                frame.origin = CGPoint.zero
                self.popupedViewOwner.frame = frame
                
                //change overlay alpha
                self.overlayView.alpha = CGFloat(self.overlayViewAlpha)
            }, completion: { (finished) in
                self.isAnimatingNow = false
                self.popupDidAppear(animated: animated)
            })
        } else
        {
            //placed
            var frame = popupedViewOwner.frame
            frame.origin = CGPoint.zero
            popupedViewOwner.frame = frame
            
            self.popupDidAppear(animated: animated)
        }
    }
    
    func hide(animated: Bool)
    {
        if !isShow || isAnimatingNow { return }
        
        self.popupWillDisappear(animated: animated)
        
        if animated
        {
            isAnimatingNow = true
            
            //animations
            UIView.animate(withDuration: SMPopupViewController.motionDuration, animations: { 
                //motion
                var frame = self.popupedViewOwner.frame
                frame.origin.y = self.view.bounds.size.height
                self.popupedViewOwner.frame = frame
                
                //change overlay alpha
                self.overlayView.alpha = 0.0
            }, completion: { (finished) in
                self.isAnimatingNow = false
                self.popupDidDisappear(animated: animated)
            })
        } else
        {
            self.popupDidDisappear(animated: animated)
        }
    }
    
    func hidedButtonPressed(sender: AnyObject)
    {
        self.hide(animated: true)
    }
    
    override var preferredContentSize: CGSize
    {
        get
        {
            if popupedView.bounds.size != CGSize.zero
            {
                return popupedView.bounds.size
            } else
            {
                return SMPopupView.popupViewSize()
            }
        }
        set
        {
            super.preferredContentSize = newValue
        }
    }

}
