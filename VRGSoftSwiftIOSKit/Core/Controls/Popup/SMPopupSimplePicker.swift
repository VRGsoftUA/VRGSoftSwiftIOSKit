//
//  SMPopupSimplePicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMPopupSimplePicker: SMPopupPicker, UIPickerViewDelegate, UIPickerViewDataSource
{
    public static let kSMPopupPickerValueDidChange: String = "kSMPopupPickerValueDidChange"
    
    
    // MARK: override next methods to customize:
    
    override open func createPicker() -> UIView?
    {
        let pv: UIPickerView = UIPickerView(frame: CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize()))
        pv.delegate = self
        pv.dataSource = self
        pv.showsSelectionIndicator = true
        
        return pv
    }
    
    open var _dataSource: [AnyObject] = []
    open var dataSource: [AnyObject]
    {
        set
        {
            _dataSource = newValue
            popupedPicker?.reloadAllComponents()
        }
        get
        {
            return _dataSource
        }
    }
    
    open var popupedPicker: UIPickerView?
    {
        return picker as? UIPickerView
    }
    
    
    // MARK: override next methods to change default behaviours
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return _dataSource.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var result: String?
        
        if row >= 0 && row < _dataSource.count
        {
            let item: AnyObject = _dataSource[row]
            
            if item is SMTitledID
            {
                result = (item as? SMTitledID)?.title
            } else if item is String
            {
                result = item as? String
            } else if let itemConforms: SMPopupPickerItemTitled = item as? SMPopupPickerItemTitled
            {
                result = itemConforms.itemTitled
            } else
            {
                assert(false, "Wrong class in dataSource !!!")
            }
        }
        
        return result
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMPopupSimplePicker.kSMPopupPickerValueDidChange), object: self)
        if let selectedItem: AnyObject = selectedItem
        {
            selectHandler?(self, selectedItem)
        }
    }
    
    override open var selectedItem: AnyObject?
    {
        get
        {
            guard let index: Int = popupedPicker?.selectedRow(inComponent: 0) else
            {
                return nil
            }
            return index < _dataSource.count ? _dataSource[index] : nil
        }
        set
        {
            if newValue != nil
            {
                let index: Int! = _dataSource.index(where: { item -> Bool in
                    item.isEqual(newValue)
                })
                if let index: Int = index
                {
                    popupedPicker?.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
    }
    
    override open func popupWillAppear(animated: Bool)
    {
        super.popupWillAppear(animated: animated)
        
        selectedItem = super.selectedItem
    }
}
