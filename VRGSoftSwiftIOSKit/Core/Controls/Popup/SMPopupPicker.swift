//
//  SMPopupPicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

typealias SMPickeSelectHendlerBlock = (SMPopupPicker, AnyObject) -> ()

open class SMPopupPicker: SMPopupView
{
    var selectHandler: SMPickeSelectHendlerBlock?
    
    var picker: UIView! = UIView()
    
    
    // Create, configure and return popupedView
    
    override func setup()
    {
        super.setup()
        self.frame = CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize())
        self.backgroundColor = .clear
        picker = self.createPicker()
        self.addSubview(picker)
        self.configureFrames()
    }
    
    func configureFrames()
    {
        self.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        picker.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        if _toolbar != nil
        {
            var newFrame = picker.frame
            newFrame.origin.y = _toolbar!.bounds.size.height
            picker.frame = newFrame
            
            newFrame.origin.y = 0
            newFrame.size.height += _toolbar!.bounds.size.height
            self.frame = newFrame
        }
        
        picker.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    var _toolbar: SMToolbar?
    var toolbar: SMToolbar?
    {
        set
        {
            if _toolbar == newValue { return }
            
            if newValue != nil
            {
                _toolbar = newValue
                self.addSubview(_toolbar!)
                _toolbar?.sizeToFit()
                _toolbar?.autoresizingMask = .flexibleWidth
                
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
    
    func createPicker() -> UIView?
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
