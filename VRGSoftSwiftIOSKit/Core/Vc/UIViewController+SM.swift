//
//  UIViewController+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/23/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UIViewController {

    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController: UINavigationController = controller as? UINavigationController {
            
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController: UITabBarController = controller as? UITabBarController {
            
            if let selected: UIViewController = tabController.selectedViewController {
                
                return topViewController(controller: selected)
            }
        }
        
        if let presented: UIViewController = controller?.presentedViewController {
            
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    @discardableResult
    func showAlertController(title aTitle: String?, message aMessage: String?, cancelButtonTitle aCancelButtonTitle: String?) -> SMAlertController? {
        
        if aTitle == nil && aMessage == nil {
            
            return nil
        }
        
        return showAlertController(title: aTitle, message: aMessage, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: nil)
        
    }

    @discardableResult
    func showAlertController(title aTitle: String?,
                             message aMessage: String?,
                             cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                             otherButtonTitles aOtherButtonTitles: [String]?,
                             processHandler aProcessHandler: SMAlertControllerProcessHandlerType? = nil,
                             handler aHandler: SMAlertControllerCompletionHandlerType? = nil) -> SMAlertController {
        return SMAlertController.showAlertController(title: aTitle, message: aMessage, fromVC: base, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, processHandler: aProcessHandler, handler: aHandler)
    }
    
    @discardableResult
    func showSheetController(title aTitle: String?,
                             message aMessage: String?,
                             cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                             otherButtonTitles aOtherButtonTitles: [String]?,
                             processHandler aProcessHandler: SMAlertControllerProcessHandlerType? = nil,
                             handler aHandler: SMAlertControllerCompletionHandlerType? = nil) -> SMAlertController {
        return SMAlertController.showSheetController(title: aTitle, message: aMessage, fromVC: base, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, processHandler: aProcessHandler, handler: aHandler)
    }
}


extension UIViewController: SMCompatible { }
