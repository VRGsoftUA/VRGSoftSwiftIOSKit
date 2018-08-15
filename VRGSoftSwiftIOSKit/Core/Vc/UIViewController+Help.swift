//
//  UIViewController.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/23/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

extension UIViewController
{
    open class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController: UINavigationController = controller as? UINavigationController
        {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController: UITabBarController = controller as? UITabBarController
        {
            if let selected: UIViewController = tabController.selectedViewController
            {
                return topViewController(controller: selected)
            }
        }
        
        if let presented: UIViewController = controller?.presentedViewController
        {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    open func sm_showAlertController(title aTitle: String?, message aMessage: String?, cancelButtonTitle aCancelButtonTitle: String?)
    {
        if aTitle == nil && aMessage == nil
        {
            return
        }
        
        self.sm_showAlertController(title: aTitle, message: aMessage, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: nil, handler: nil)
    }

    open func sm_showAlertController(title aTitle: String?,
                                     message aMessage: String?,
                                     cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                     otherButtonTitles aOtherButtonTitles: [String]?,
                                     handler aHandler: ((_ aVc: SMAlertController, _ aButtonIndex: Int)  -> Swift.Void)? = nil)
    {
        SMAlertController.showAlertController(style: .alert, title: aTitle, message: aMessage, fromVC: self, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, handler: aHandler)
    }
    
    open func sm_showSheetController(title aTitle: String?,
                                     message aMessage: String?,
                                     cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                     otherButtonTitles aOtherButtonTitles: [String]?,
                                     handler aHandler: ((_ aVc: SMAlertController, _ aButtonIndex: Int)  -> Swift.Void)? = nil)
    {
        SMAlertController.showAlertController(style: .actionSheet, title: aTitle, message: aMessage, fromVC: self, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, handler: aHandler)
    }
}
