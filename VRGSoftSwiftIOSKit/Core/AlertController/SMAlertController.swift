//
//  SMAlertController.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/23/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMAlertController: UIAlertController
{
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMAlertController.hide), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    open func show() -> Void
    {
        self.showFrom(vc: UIViewController.topViewController()!)
    }
    
    @objc open func hide() -> Void
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    open func showFrom(vc aVc: UIViewController) ->Void
    {
        aVc.present(self, animated: true, completion: nil)
    }
    
    open class func showAlertController(style aStyle: UIAlertControllerStyle,
                                        title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        handler aHandler: ((_ aVc: SMAlertController,_ aButtonIndex: Int)  -> Swift.Void)? = nil) -> Void
    {
        let alertController: SMAlertController = SMAlertController(title: aTitle, message: aMessage, preferredStyle: aStyle)
        
        weak var __alertController = alertController
        
        let cancelAction: UIAlertAction = UIAlertAction(title: aCancelButtonTitle, style: UIAlertActionStyle.cancel) { (_ action: UIAlertAction) in
            if aHandler != nil
            {
                aHandler!(__alertController!,0)
            }
        }
        alertController.addAction(cancelAction)
        
        if aOtherButtonTitles != nil
        {
            var i: Int = 0
            for title in aOtherButtonTitles!
            {
                let j = i
                let action: UIAlertAction = UIAlertAction(title: title, style: UIAlertActionStyle.default) { (_ action: UIAlertAction) in
                    if aHandler != nil
                    {
                        aHandler!(__alertController!,j+1)
                    }
                }
                i = i+1
                alertController.addAction(action)
            }
        }
        
        alertController.showFrom(vc: aVC)
    }
    
    open class func showAlertController(title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        handler aHandler: ((_ aVc: SMAlertController,_ aButtonIndex: Int)  -> Swift.Void)? = nil) -> Void
    {
        showAlertController(style: .alert, title: aTitle, message: aMessage, fromVC: aVC, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, handler: aHandler)
    }
    
    open class func showSheetController(title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        handler aHandler: ((_ aVc: SMAlertController,_ aButtonIndex: Int)  -> Swift.Void)? = nil) -> Void
    {
        showAlertController(style: .actionSheet, title: aTitle, message: aMessage, fromVC: aVC, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, handler: aHandler)
    }
}
