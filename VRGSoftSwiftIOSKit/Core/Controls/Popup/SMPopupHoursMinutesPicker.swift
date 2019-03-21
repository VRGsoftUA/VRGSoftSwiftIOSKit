//
//  SMPopupHoursMinutesPicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMPopupHoursMinutesPicker: SMPopupPicker, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: override next methods to customize:
    
    override open func createPicker() -> UIView? {
        
        let pv: UIPickerView = UIPickerView(frame: CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize()))
        pv.delegate = self
        pv.dataSource = self
        pv.showsSelectionIndicator = true
        
        return pv
    }
    
    open var popupedPicker: UIPickerView? {
        get {
            return picker as? UIPickerView
        }
        set {
            picker = newValue
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (component == 0) ? 24 : 60
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    override open var selectedItem: AnyObject? {
        get {
            guard let hours: Int = popupedPicker?.selectedRow(inComponent: 0),
                 let minutes: Int = popupedPicker?.selectedRow(inComponent: 1) else {
                return nil
            }
            return NSNumber(value: 60 * hours + minutes)
        }
        set {
            _selectedItem = newValue
        }
    }
    
    override open func popupWillAppear(animated: Bool) {
        super.popupWillAppear(animated: animated)
        
        var newFrame: CGRect
        
        //hours
        if  UIApplication.shared.statusBarOrientation.isPortrait {
            newFrame = CGRect(x: 60, y: 130, width: 70, height: 44)
        } else {
            newFrame = CGRect(x: 60, y: 90, width: 70, height: 44)
        }
        
        let lbHours: UILabel = UILabel(frame: newFrame)
        lbHours.text = "hours"
        lbHours.backgroundColor = .clear
        self.addSubview(lbHours)
        
        //minutes
        if UIApplication.shared.statusBarOrientation.isPortrait {
            newFrame = CGRect(x: 200, y: 130, width: 70, height: 44)
        } else {
            newFrame = CGRect(x: 370, y: 90, width: 70, height: 44)
        }
        
        let lbMinutes: UILabel = UILabel(frame: newFrame)
        lbMinutes.text = "minutes"
        lbMinutes.backgroundColor = .clear
        lbMinutes.autoresizingMask = .flexibleLeftMargin
        self.addSubview(lbMinutes)
        
        //setup current view
        if selectedItem != nil {
            
            guard let selNumber: NSNumber = selectedItem as? NSNumber else { return }
            
            popupedPicker?.selectRow(selNumber.intValue/60, inComponent: 0, animated: false)
            popupedPicker?.selectRow(selNumber.intValue%60, inComponent: 1, animated: false)
        }
    }
}
