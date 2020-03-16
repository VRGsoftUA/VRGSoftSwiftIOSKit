//
//  SMPopupCustomSimplePicker.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMPopupCustomSimplePicker: SMPopupSimplePicker {
    
    open var font: UIFont?
    open var textColor: UIColor?
    open var textAlignment: NSTextAlignment?
    open var shadowColor: UIColor?
    open var shadowOffset: CGSize?
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let result: UILabel = view as? UILabel ?? UILabel(frame: CGRect(x: 20, y: 0, width: 270, height: 44))
        
        //configure label
        if view == nil {
            
            result.backgroundColor = .clear
            
            if font != nil {
                
                result.font = font
            }
            
            if textColor != nil {
                
                result.textColor = textColor
            }
            
            if shadowColor != nil {
                
                result.shadowColor = shadowColor
            }
            
            if let shadowOffset: CGSize = shadowOffset {
                
                result.shadowOffset = shadowOffset
            }
            
            if let textAlignment: NSTextAlignment = textAlignment {
                
                result.textAlignment = textAlignment
            }
        }
        
        
        //setup text
        if row < dataSource.count {
            
            let item: AnyObject = dataSource[row]
            
            if let item: SMTitledID = item as? SMTitledID {
                
                result.text = item.title
            } else if let item: String = item as? String {
                
                result.text = item
            } else if let itemConforms: SMPopupPickerItemTitled = item as? SMPopupPickerItemTitled {
                
                result.text = itemConforms.itemTitled
            } else {
                
                assert(false, "Wrong class in dataSource !!!")
            }
        } else {
            
            result.text = nil
        }
        
        return result
    }
}
