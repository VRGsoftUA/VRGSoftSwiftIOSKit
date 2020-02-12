//
//  SMAlertController.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/23/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMAlertControllerCompletionHandlerType = (_ aVc: SMAlertController, _ aButtonIndex: Int) -> Void
public typealias SMAlertControllerProcessHandlerType = (_ aVc: SMAlertController) -> Void


open class SMAlertController: UIAlertController {
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMAlertController.hide), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    open func show() {
        
        if let topViewController: UIViewController = UIViewController.sm.topViewController() {
            
            self.showFrom(vc: topViewController)
        }
    }
    
    @objc open func hide() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    open func showFrom(vc aVc: UIViewController) {
        
        aVc.present(self, animated: true, completion: nil)
    }
    
    @discardableResult
    open class func showAlertController(style aStyle: UIAlertController.Style,
                                        title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        processHandler aProcessHandler: SMAlertControllerProcessHandlerType? = nil,
                                        handler aHandler: SMAlertControllerCompletionHandlerType? = nil) -> SMAlertController {
        
        let alertController: SMAlertController = SMAlertController(title: aTitle, message: aMessage, preferredStyle: aStyle)
        
        unowned let __alertController: SMAlertController = alertController
        
        let cancelAction: UIAlertAction = UIAlertAction(title: aCancelButtonTitle, style: UIAlertAction.Style.cancel) { (_ action: UIAlertAction) in
            aHandler?(__alertController, 0)
        }
        
        alertController.addAction(cancelAction)
        
        if let otherButtonTitles: [String] = aOtherButtonTitles {
            
            var i: Int = 0
            
            for title: String in otherButtonTitles {
                
                let j: Int = i
                
                let action: UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.default) { (_ action: UIAlertAction) in
                    aHandler?(__alertController, j+1)
                }
                
                i = i+1
                
                alertController.addAction(action)
            }
        }
        
        aProcessHandler?(__alertController)
        
        alertController.showFrom(vc: aVC)
        
        return alertController
    }
    
    @discardableResult
    open class func showAlertController(title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        processHandler aProcessHandler: SMAlertControllerProcessHandlerType? = nil,
                                        handler aHandler: SMAlertControllerCompletionHandlerType? = nil) -> SMAlertController {
        return showAlertController(style: .alert,
                                   title: aTitle,
                                   message: aMessage,
                                   fromVC: aVC,
                                   cancelButtonTitle: aCancelButtonTitle,
                                   otherButtonTitles: aOtherButtonTitles,
                                   processHandler: aProcessHandler,
                                   handler: aHandler)
    }
    
    @discardableResult
    open class func showSheetController(title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("Ok", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        processHandler aProcessHandler: SMAlertControllerProcessHandlerType? = nil,
                                        handler aHandler: SMAlertControllerCompletionHandlerType? = nil) -> SMAlertController {
        return showAlertController(style: .actionSheet,
                                   title: aTitle,
                                   message: aMessage,
                                   fromVC: aVC,
                                   cancelButtonTitle: aCancelButtonTitle,
                                   otherButtonTitles: aOtherButtonTitles,
                                   processHandler: aProcessHandler,
                                   handler: aHandler)
    }
}
