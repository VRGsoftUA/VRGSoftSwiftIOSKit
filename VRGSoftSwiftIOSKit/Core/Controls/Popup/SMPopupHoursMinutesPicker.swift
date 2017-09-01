//
//  SMPopupHoursMinutesPicker.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

class SMPopupHoursMinutesPicker: SMPopupPicker, UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK: override next methods to customize:
    
    override func createPicker() -> UIView?
    {
        let pv: UIPickerView = UIPickerView(frame: CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize()))
        pv.delegate = self
        pv.dataSource = self
        pv.showsSelectionIndicator = true
        
        return pv
    }
    
    var popupedPicker: UIPickerView
    {
        get
        {
            return picker as! UIPickerView
        }
        set
        {
            self.popupedPicker = newValue
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return (component == 0) ? 24 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(row)"
    }
    
    override var selectedItem: AnyObject?
    {
        get
        {
            let hours = self.popupedPicker.selectedRow(inComponent: 0)
            let minutes = self.popupedPicker.selectedRow(inComponent: 1)
            return NSNumber(value: 60 * hours + minutes)
        }
        set
        {
            self.selectedItem = newValue
        }
    }
    
    override func popupWillAppear(animated: Bool)
    {
        super.popupWillAppear(animated: animated)
        
        var newFrame: CGRect
        
        //hours
        if  UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        {
            newFrame = CGRect(x: 60, y: 130, width: 70, height: 44)
        } else
        {
            newFrame = CGRect(x: 60, y: 90, width: 70, height: 44)
        }
        
        let lbHours: UILabel = UILabel(frame: newFrame)
        lbHours.text = "hours"
        lbHours.backgroundColor = .clear
        self.addSubview(lbHours)
        
        //minutes
        if  UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        {
            newFrame = CGRect(x: 200, y: 130, width: 70, height: 44)
        } else
        {
            newFrame = CGRect(x: 370, y: 90, width: 70, height: 44)
        }
        
        let lbMinutes: UILabel = UILabel(frame: newFrame)
        lbMinutes.text = "minutes"
        lbMinutes.backgroundColor = .clear
        lbMinutes.autoresizingMask = .flexibleLeftMargin
        self.addSubview(lbMinutes)
        
        //setup current view
        if selectedItem != nil
        {
            let selNumber: NSNumber = selectedItem as! NSNumber
            popupedPicker.selectRow(selNumber.intValue/60, inComponent: 0, animated: false)
            popupedPicker.selectRow(selNumber.intValue%60, inComponent: 1, animated: false)
        }
    }
}
