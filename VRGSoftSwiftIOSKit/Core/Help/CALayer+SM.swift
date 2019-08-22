//
//  CALayer+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: CALayer {
    
    func imageCreate() -> UIImage? {
        
        var result: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, false, UIScreen.main.scale)
        
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            
            base.render(in: context)
            result = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return result
    }
}


extension CALayer: SMCompatible { }
