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
        
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable open var borderWidth: CGFloat {
        
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
}
