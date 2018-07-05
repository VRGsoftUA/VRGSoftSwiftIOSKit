//
//  SMPopupDatePicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMPopupDatePicker: SMPopupPicker
{
    // MARK: override next methods to customize:
    
    override func createPicker() -> UIView?
    {
        let pv: UIDatePicker = UIDatePicker(frame: CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize()))
        pv.datePickerMode = .date
        pv.addTarget(self, action: #selector(SMPopupDatePicker.didPopupDatePickerChanged(sender:)), for: .valueChanged)
        
        return pv
    }
    
    var popupedPicker: UIDatePicker?
    {
        return self.picker as? UIDatePicker
    }
    
    override open var selectedItem: AnyObject?
    {
        get
        {
            return self.popupedPicker?.date as AnyObject
        }
        set
        {
            guard let date = newValue as? Date else
            {
                return
            }
            self.popupedPicker?.date = date
        }
    }
    
    override func popupWillAppear(animated: Bool)
    {
        super.popupWillAppear(animated: animated)
        
        //setup current value
        if let selectedItem = selectedItem as? Date
        {
            self.popupedPicker?.date = selectedItem
        } else
        {
            assert(false, "Wrong class type !!!")
        }
    }
    
    
    // MARK: - Actions
    
    @objc func didPopupDatePickerChanged(sender: AnyObject)
    {
        if let selectedItem = selectedItem
        {
            self.selectHandler?(self, selectedItem)
        }
    }
}
