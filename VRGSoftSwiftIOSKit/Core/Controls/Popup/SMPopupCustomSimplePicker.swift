//
//  SMPopupCustomSimplePicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMPopupCustomSimplePicker: SMPopupSimplePicker
{
    open var font: UIFont?
    open var textColor: UIColor?
    open var textAlignment: NSTextAlignment?
    open var shadowColor: UIColor?
    open var shadowOffset: CGSize?
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let result: UILabel = view as? UILabel ?? UILabel(frame: CGRect(x: 20, y: 0, width: 270, height: 44))
        
        //configure label
        if view == nil
        {
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
            if let shadowOffset = shadowOffset
            {
                result.shadowOffset = shadowOffset
            }
            if let textAlignment = textAlignment
            {
                result.textAlignment = textAlignment
            }
        }
        
        
        //setup text
        if row < dataSource.count
        {
            let item = dataSource[row]
            if item is SMTitledID
            {
                result.text = (item as? SMTitledID)?.title
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
