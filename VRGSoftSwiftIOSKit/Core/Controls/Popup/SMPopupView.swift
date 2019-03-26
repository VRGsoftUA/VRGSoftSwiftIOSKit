//
//  SMPopupView.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/18/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMPopupView: UIView {
    
    public static let kSMPopupViewWillShow: String = "kSMPopupViewWillShow"
    public static let kSMPopupViewDidShow: String = "kSMPopupViewDidShow"
    public static let kSMPopupViewWillHide: String = "kSMPopupViewWillHide"
    public static let kSMPopupViewDidHide: String = "kSMPopupViewDidHide"
    public static let kSMPopupViewNeedHide: String = "kSMPopupViewNeedHide"
    
    open var showStrategy: UIViewController?
    open var isShowOverlayView: Bool = false
    open var isHideByTapOutside: Bool = true
    open var isVisible: Bool = false
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setup()
    }
    
    public class func popupViewSize() -> CGSize {
        
        return CGSize(width: 320, height: 216)
    }
    
    open func setup() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationNeedHide(aNotification:)), name: NSNotification.Name(rawValue: SMPopupView.kSMPopupViewNeedHide), object: nil)
    }
    
    
    // MARK: Notification
    
    @objc open func notificationNeedHide(aNotification: Notification) {
        
        self.hide(animated: true)
    }
    
    open func prepareToShow() {
        
        showStrategy = nil
        
        if SMHelper.isIPad {
            
            let popupController: SMDefaultPopupViewController = SMDefaultPopupViewController()
            popupController.popupedView = self
            popupController.modalPresentationStyle = .popover
            showStrategy = popupController
        } else {
            
            let popupController: SMPopupViewController = SMPopupViewController()
            popupController.popupedView = self
            showStrategy = popupController
        }
    }
    
    open func popupWillAppear(animated: Bool) {
        
        self.isVisible = true
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMPopupView.kSMPopupViewWillShow), object: self)
    }
    
    open func popupDidAppear(animated: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMPopupView.kSMPopupViewDidShow), object: self)
    }
    
    open func popupWillDisappear(animated: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMPopupView.kSMPopupViewWillHide), object: self)
    }
    
    open func popupDidDisappear(animated: Bool) {
        
        showStrategy = nil
        
        isVisible = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMPopupView.kSMPopupViewDidHide), object: self)
    }
    
    open func hide(animated: Bool) {
        
        if SMHelper.isIPad {
            
            showStrategy?.dismiss(animated: animated, completion: nil)
        } else {
            
            (showStrategy as? SMPopupViewController)?.hide(animated: animated)
        }
    }
    
    @objc open func show(animated: Bool, inView aView: UIView) {
        
        if !SMHelper.isIPad {
            
            var newFrame: CGRect = self.frame
            newFrame.size.width = aView.frame.size.width
            self.frame = newFrame
            (showStrategy as? SMPopupViewController)?.show(animated: animated, inView: aView)
        } else {
            
            assert(false, String(format: "%@: use %@", NSStringFromClass(type(of: self)), NSStringFromSelector(#selector(SMPopupView.showFrom(rect:inView:permittedArrowDirections:)))))
        }
    }
    
    @objc open func showFrom(rect: CGRect, inView aView: UIView, permittedArrowDirections directions: UIPopoverArrowDirection) {
        
        if SMHelper.isIPad {
            
            if let vc: UIViewController = showStrategy,
                let popover: UIPopoverPresentationController  = vc.popoverPresentationController {
                
                vc.view = self
                vc.preferredContentSize = self.size
                popover.sourceRect = rect
                popover.sourceView = aView
                popover.permittedArrowDirections = directions
                aView.sm_parentViewController?.present(vc, animated: true, completion: nil)
            }
        } else {
            
            assert(false, String(format: "%@: use %@", NSStringFromClass(type(of: self)), NSStringFromSelector(#selector(SMPopupView.show(animated:inView:)))))
        }
    }
}

private class SMDefaultPopupViewController: UIViewController {
    
    var popupedView: SMPopupView?
    
    override open func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        popupedView?.popupWillAppear(animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        popupedView?.popupDidAppear(animated: animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        popupedView?.popupWillDisappear(animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        popupedView?.popupDidDisappear(animated: animated)
    }
}
