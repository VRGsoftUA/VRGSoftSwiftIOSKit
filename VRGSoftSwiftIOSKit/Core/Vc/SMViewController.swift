//
//  SMViewController.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/21/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMViewControllerCallback = (SMViewController, AnyObject) -> Void

@objc public class SMViewController: UIViewController
{
    var callBack: SMViewControllerCallback?
    
    open func performCallBackWith(sender aSender: AnyObject, goBack isGoBack: Bool) -> Void
    {
        if self.callBack != nil
        {
            self.callBack!(self,aSender)
        }
        
        if isGoBack
        {
            self.close()
        }
    }
    
    var _activity: SMActivityAdapter?
    var activity: SMActivityAdapter
    {
        get
        {
            if _activity == nil
            {
                _activity = SMActivityPKHUD()
            }
            
            return _activity!
        }
    }
    
    open func showActivity() -> Void
    {
        self.activity.configureWith(view: self.view)
        self.activity.show()
    }

    open func hideActivity() -> Void
    {
        self.activity.hide()
    }

    open var isFirstAppear: Bool = true
    
    open var isModal: Bool
    {
        return (self.navigationController?.childViewControllers[0] == self || self.navigationController == nil)
    }
    
    var _backgroundImageView: UIImageView?
    open var backgroundImageView: UIImageView?
    {
        return _backgroundImageView
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()

        // bg image
        let bgImage:UIImage? = self.backgroundImage()
        if bgImage != nil
        {
            let frame : CGRect = self.view.bounds
            
            _backgroundImageView = UIImageView(frame: frame)
            _backgroundImageView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            _backgroundImageView?.contentMode = .center
            _backgroundImageView?.image = bgImage
            self.view.addSubview(_backgroundImageView!)
            self.view.sendSubview(toBack: _backgroundImageView!)
        }

        // left nav button
        if !self.navigationItem.hidesBackButton
        {
            let leftNavigationButton: UIBarButtonItem? = self.createLeftNavButton()
            if leftNavigationButton != nil
            {
                if leftNavigationButton?.customView is UIButton
                {
                    (leftNavigationButton?.customView as! UIButton).addTarget(self, action: #selector(self.didBtNavLeftClicked), for: UIControlEvents.touchUpInside)
                } else
                {
                    leftNavigationButton?.target = self
                    leftNavigationButton?.action = #selector(self.didBtNavLeftClicked)
                }
                
                self.navigationItem.leftBarButtonItem = leftNavigationButton
            }
        }
        
        // right nav button
        let rightNavigationButton: UIBarButtonItem? = self.createRightNavButton()
        if rightNavigationButton != nil
        {
            if rightNavigationButton?.customView is UIButton
            {
                (rightNavigationButton?.customView as! UIButton).addTarget(self, action: #selector(self.didBtNavRightClicked), for: UIControlEvents.touchUpInside)
            } else
            {
                rightNavigationButton?.target = self
                rightNavigationButton?.action = #selector(self.didBtNavRightClicked)
            }
            
            self.navigationItem.rightBarButtonItem = rightNavigationButton
        }
        
        // custom title view for nav.item
        let titleView:UIView? = self.createTitleViewNavItem()
        if titleView != nil
        {
            self.navigationItem.titleView = titleView
        }
    }

    open func backgroundImage() -> UIImage?
    {
        return nil
    }

    open func createLeftNavButton() -> UIBarButtonItem?
    {
        return nil
    }

    open func createRightNavButton() -> UIBarButtonItem?
    {
        return nil
    }

    open func createTitleViewNavItem() -> UIView?
    {
        return nil
    }
    
    override open func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.isFirstAppear = false
    }

    
    // MARK: - Actions
    
    @objc open func didBtNavLeftClicked()
    {
        self.close()
    }

    open func close()
    {
        if self.isModal
        {
            self.dismiss(animated: true, completion: nil)
        } else
        {
            self.navigationController!.popViewController(animated: true)
        }
    }

    @objc open func didBtNavRightClicked()
    {
        
    }
}
