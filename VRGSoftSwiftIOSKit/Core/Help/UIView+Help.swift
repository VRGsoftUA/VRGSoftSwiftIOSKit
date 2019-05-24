//
//  UIView+Help.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/22/19.
//  Copyright © 2019 OLEKSANDR SEMENIUK. All rights reserved.
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
