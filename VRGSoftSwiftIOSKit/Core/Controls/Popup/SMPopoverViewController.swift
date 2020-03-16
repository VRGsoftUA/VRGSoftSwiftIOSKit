//
//  SMPopoverViewController.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/18/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMPopoverViewController: UIViewController {
    
    var popupedView: SMPopupView
    var popoverOwner: UIViewController?
    
    init(popupView aPopupView: SMPopupView) {
        
        popupedView = aPopupView
        
        super.init(nibName: nil, bundle: nil)
        isModalInPopover = !(popupedView.isHideByTapOutside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.bounds = popupedView.bounds
        
        self.view.addSubview(popupedView)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        popupedView.popupWillAppear(animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        popupedView.popupDidAppear(animated: animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        popupedView.popupWillDisappear(animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        popupedView.popupDidDisappear(animated: animated)
    }
    
    override open var preferredContentSize: CGSize {
        get {
            return popupedView.bounds.size
        }
        set {
            super.preferredContentSize = newValue
        }
    }
}
