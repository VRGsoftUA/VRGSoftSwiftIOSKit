//
//  CALayer+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/22/19.
//  Copyright © 2019 OLEKSANDR SEMENIUK. All rights reserved.
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
