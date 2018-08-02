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
    
    open func show()
    {
        if let topViewController: UIViewController = UIViewController.topViewController()
        {
            self.showFrom(vc: topViewController)
        }
    }
    
    @objc open func hide()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    open func showFrom(vc aVc: UIViewController)
    {
        aVc.present(self, animated: true, completion: nil)
    }
    
    open class func showAlertController(style aStyle: UIAlertControllerStyle,
                                        title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        handler aHandler: ((_ aVc: SMAlertController, _ aButtonIndex: Int)  -> Swift.Void)? = nil)
    {
        let alertController: SMAlertController = SMAlertController(title: aTitle, message: aMessage, preferredStyle: aStyle)
        
        unowned let __alertController: SMAlertController = alertController
        
        let cancelAction: UIAlertAction = UIAlertAction(title: aCancelButtonTitle, style: UIAlertActionStyle.cancel) { (_ action: UIAlertAction) in
            aHandler?(__alertController, 0)
        }
        alertController.addAction(cancelAction)
        
        if let otherButtonTitles: [String] = aOtherButtonTitles
        {
            var i: Int = 0
            for title: String in otherButtonTitles
            {
                let j: Int = i
                let action: UIAlertAction = UIAlertAction(title: title, style: UIAlertActionStyle.default) { (_ action: UIAlertAction) in
                    aHandler?(__alertController, j+1)
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
                                        handler aHandler: ((_ aVc: SMAlertController, _ aButtonIndex: Int)  -> Swift.Void)? = nil)
    {
        showAlertController(style: .alert, title: aTitle, message: aMessage, fromVC: aVC, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, handler: aHandler)
    }
    
    open class func showSheetController(title aTitle: String?,
                                        message aMessage: String?,
                                        fromVC aVC: UIViewController,
                                        cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("Ok", comment: ""),
                                        otherButtonTitles aOtherButtonTitles: [String]?,
                                        handler aHandler: ((_ aVc: SMAlertController, _ aButtonIndex: Int)  -> Swift.Void)? = nil)
    {
        showAlertController(style: .actionSheet, title: aTitle, message: aMessage, fromVC: aVC, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: aOtherButtonTitles, handler: aHandler)
    }
}
