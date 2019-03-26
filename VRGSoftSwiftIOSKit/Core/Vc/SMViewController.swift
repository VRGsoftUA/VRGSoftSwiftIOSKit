//
//  SMViewController.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/21/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMViewControllerCallback = (SMViewController, Any?) -> Void

@objc open class SMViewController: UIViewController {
    
    open var callBack: SMViewControllerCallback?
    
    open func performCallBackWith(sender aSender: Any?, goBack isGoBack: Bool) {
        
        self.callBack?(self, aSender)
        
        if isGoBack {
            
            self.close()
        }
    }
    
    open var isVisible: Bool = false
    
    open lazy var activity: SMActivityAdapter = createActivity()
    
    open func createActivity() -> SMActivityAdapter {
        
        return SMNativeActivityAdapter()
    }
    
    open func showActivity() {
        
        self.activity.show()
    }

    open func hideActivity() {
        
        self.activity.hide()
    }

    open var isFirstAppear: Bool = true
    
    open var isModal: Bool {
        
        return (self.navigationController?.children[0] == self || self.navigationController == nil)
    }
    
    open lazy var backgroundImageView: UIImageView = UIImageView()
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()

        // bg image
        
        if let bgImage: UIImage = self.backgroundImage() {
            
            backgroundImageView.frame = self.view.bounds
            backgroundImageView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            backgroundImageView.contentMode = .center
            backgroundImageView.image = bgImage
            self.view.addSubview(backgroundImageView)
            self.view.sendSubviewToBack(backgroundImageView)
        }

        // left nav button
        if !self.navigationItem.hidesBackButton {
            
            if let leftNavigationButton: UIBarButtonItem = self.createLeftNavButton() {
                
                if let leftNavigationButton: UIButton = leftNavigationButton.customView as? UIButton {
                    
                    leftNavigationButton.addTarget(self, action: #selector(self.didBtNavLeftClicked), for: UIControl.Event.touchUpInside)
                } else {
                    
                    leftNavigationButton.target = self
                    leftNavigationButton.action = #selector(self.didBtNavLeftClicked)
                }
                
                if let leftBbis: [UIBarButtonItem] = self.createLeftNavButtonsAdditionals(), !leftBbis.isEmpty {
                    
                    var fullLeftBbis: [UIBarButtonItem] = [leftNavigationButton]
                    fullLeftBbis.append(contentsOf: leftBbis)
                    self.navigationItem.leftBarButtonItems = fullLeftBbis
                } else {
                    
                    self.navigationItem.leftBarButtonItem = leftNavigationButton
                }
            }
        }
        
        // right nav button
        if let rightNavigationButton: UIBarButtonItem = self.createRightNavButton() {
            
            if let rightNavigationButton: UIButton = rightNavigationButton.customView as? UIButton {
                
                rightNavigationButton.addTarget(self, action: #selector(self.didBtNavRightClicked), for: UIControl.Event.touchUpInside)
            } else {
                rightNavigationButton.target = self
                rightNavigationButton.action = #selector(self.didBtNavRightClicked)
            }
            
            if let rightBbis: [UIBarButtonItem] = self.createRightNavButtonsAdditionals(), !rightBbis.isEmpty {
                
                var fullRightBbis: [UIBarButtonItem] = [rightNavigationButton]
                fullRightBbis.append(contentsOf: rightBbis)
                self.navigationItem.rightBarButtonItems = fullRightBbis
            } else {
                
                self.navigationItem.rightBarButtonItem = rightNavigationButton
            }
        }
        
        // custom title view for nav.item
        if let titleView: UIView = self.createTitleViewNavItem() {
            
            self.navigationItem.titleView = titleView
        }
        
        self.activity.configureWith(view: self.view)
    }

    open func backgroundImage() -> UIImage? {
        
        return nil
    }

    open func createLeftNavButton() -> UIBarButtonItem? {
        
        return nil
    }
    
    open func createLeftNavButtonsAdditionals() -> [UIBarButtonItem]? {
        
        return nil
    }

    open func createRightNavButton() -> UIBarButtonItem? {
        
        return nil
    }
    
    open func createRightNavButtonsAdditionals() -> [UIBarButtonItem]? {
        
        return nil
    }

    open func createTitleViewNavItem() -> UIView? {
        
        return nil
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.isFirstAppear = false
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        isVisible = true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        isVisible = false
    }

    
    // MARK: - Actions
    
    @objc open func didBtNavLeftClicked() {
        
        self.close()
    }

    @objc open func didBtNavRightClicked() {
        
    }

    open func close() {
        
        if self.isModal {
            
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
