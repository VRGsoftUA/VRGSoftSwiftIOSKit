//
//  SMPopupTimePicker.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/22/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMPopupTimePicker: SMPopupDatePicker
{
    // MARK: override next methods to customize:
    
    override func createPicker() -> UIView?
    {
        let pv: UIDatePicker = UIDatePicker(frame: CGRect(origin: CGPoint.zero, size: SMPopupView.popupViewSize()))
        pv.datePickerMode = .time
        pv.addTarget(self, action: #selector(SMPopupDatePicker.didPopupDatePickerChanged(sender:)), for: .valueChanged)
        
        return pv
    }
}
