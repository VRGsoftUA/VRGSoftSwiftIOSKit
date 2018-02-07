//
//  SMPopupDatePicker.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMPopupDatePicker: SMPopupPicker
{
    //MARK: override next methods to customize:
    
    override func createPicker() -> UIView?
    {
        let pv: UIDatePicker = UIDatePicker(frame: CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize()))
        pv.datePickerMode = .date
        pv.addTarget(self, action: #selector(SMPopupDatePicker.didPopupDatePickerChanged(sender:)), for: .valueChanged)
        
        return pv
    }
    
    var popupedPicker: UIDatePicker
    {
        get
        {
            return self.picker as! UIDatePicker
        }
    }
    
    override open var selectedItem: AnyObject?
    {
        get
        {
            return self.popupedPicker.date as AnyObject
        }
        set
        {
            self.popupedPicker.date = newValue as! Date
        }
    }
    
    override func popupWillAppear(animated: Bool)
    {
        super.popupWillAppear(animated: animated)
        
        //setup current value
        if self.selectedItem != nil
        {
            if self.selectedItem is NSDate
            {
                self.popupedPicker.date = self.selectedItem as! Date
            } else
            {
                assert(false, "Wrong class type !!!")
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc func didPopupDatePickerChanged(sender: AnyObject)
    {
        if self.selectHandler != nil
        {
            self.selectHandler!(self, self.selectedItem!)
        }
    }
}
