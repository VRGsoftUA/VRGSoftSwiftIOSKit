//
//  SMPopoverViewController.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/18/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

class SMPopoverViewController: UIViewController
{
    var popupedView: SMPopupView
    var popoverOwner: UIViewController?
    
    init(popupView aPopupView: SMPopupView)
    {
        popupedView = aPopupView
        
        super.init(nibName: nil, bundle: nil)
        isModalInPopover = !(popupedView.isHideByTapOutside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.bounds = popupedView.bounds
        
        self.view.addSubview(popupedView)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        popupedView.popupWillAppear(animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        popupedView.popupDidAppear(animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        popupedView.popupWillDisappear(animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        popupedView.popupDidDisappear(animated: animated)
    }
    
    override var preferredContentSize: CGSize
    {
        get
        {
            return popupedView.bounds.size
        }
        set
        {
            super.preferredContentSize = newValue
        }
    }
    
}
