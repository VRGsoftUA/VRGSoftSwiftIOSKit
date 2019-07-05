//
//  UIImageView+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/16/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UIImageView {

    func set(image aImage: UIImage, duration aDuration: TimeInterval) {
        
        UIView.transition(with: base, duration: aDuration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.base.image = aImage
        }, completion: nil)
    }
    
    func set(image aImage: UIImage, animate aAnimate: Bool) {
        
        if aAnimate {
            
            base.sm.set(image: aImage, duration: 0.25)
        } else {
            
            base.image = aImage
        }
    }
}
