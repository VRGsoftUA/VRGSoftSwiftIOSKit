//
//  SMPopupCustomSimplePicker.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

class SMPopupCustomSimplePicker: SMPopupSimplePicker
{
    var font: UIFont?
    var textColor: UIColor?
    var textAlignment: NSTextAlignment?
    var shadowColor: UIColor?
    var shadowOffset: CGSize?
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var result: UILabel
        
        //configure label
        if view == nil
        {
            result = UILabel(frame: CGRect(x: 20, y: 0, width: 270, height: 44))
            result.backgroundColor = .clear
            
            if font != nil
            {
                result.font = font
            }
            if textColor != nil
            {
                result.textColor = textColor
            }
            if shadowColor != nil
            {
                result.shadowColor = shadowColor
            }
            if shadowOffset != nil
            {
                result.shadowOffset = shadowOffset!
            }
            if textAlignment != nil
            {
                result.textAlignment = textAlignment!
            }
        } else
        {
            result = view as! UILabel
        }
        
        //setup text
        if row < dataSource.count
        {
            let item = dataSource[row]
            if item is SMTitledID
            {
                result.text = (item as! SMTitledID).title
            } else if item is String
            {
                result.text = item.string
            } else if let itemConforms = item as? SMPopupPickerItemTitled
            {
                result.text = itemConforms.itemTitled
            } else
            {
                assert(false, "Wrong class in dataSource !!!")
            }
        } else
        {
            result.text = nil
        }
        
        return result
    }
}
