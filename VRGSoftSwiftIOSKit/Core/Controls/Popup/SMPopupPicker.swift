//
//  SMPopupPicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMPickeSelectHendlerBlock = (SMPopupPicker, AnyObject) -> Void

open class SMPopupPicker: SMPopupView
{
    public var selectHandler: SMPickeSelectHendlerBlock?
    
    open var picker: UIView?
    
    
    // Create, configure and return popupedView
    
    override open func setup()
    {
        super.setup()
        
        self.frame = CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize())
        self.backgroundColor = .clear
        
        picker = self.createPicker()
        
        if let picker: UIView = picker
        {
            self.addSubview(picker)
        }
        
        self.configureFrames()
    }
    
    open func configureFrames()
    {
        self.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        picker?.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        if let toolbar: SMToolbar = _toolbar
        {
            if var newFrame: CGRect = picker?.frame
            {
                newFrame.origin.y = toolbar.bounds.size.height
                picker?.frame = newFrame
                
                newFrame.origin.y = 0
                newFrame.size.height += toolbar.bounds.size.height
                self.frame = newFrame
            }
        }
        
        picker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    open var _toolbar: SMToolbar?
    open var toolbar: SMToolbar?
    {
        set
        {
            if _toolbar == newValue { return }
            
            _toolbar = newValue
            if let toolbar: SMToolbar = _toolbar
            {
                addSubview(toolbar)
                toolbar.sizeToFit()
                toolbar.autoresizingMask = .flexibleWidth
                
                self.configureFrames()
            } else
            {
                _toolbar?.removeFromSuperview()
                _toolbar = nil
            }
        }
        get
        {
            return _toolbar
        }
    }
    
    open func createPicker() -> UIView?
    {
        // override it in subclasses
        return nil
    }
    
    open var selectedItem: AnyObject?
    {
        // override it in subclasses
        set
        {
            self.selectedItem = newValue
        }
        get
        {
            return nil
        }
    }
}
