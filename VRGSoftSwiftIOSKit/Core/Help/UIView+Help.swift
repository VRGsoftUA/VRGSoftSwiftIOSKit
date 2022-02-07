//
//  UIView+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable open var cornerRadius: CGFloat {
        
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable open var borderWidth: CGFloat {

        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}
