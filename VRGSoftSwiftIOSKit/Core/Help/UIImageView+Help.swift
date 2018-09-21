//
//  UIImageView+Help.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/16/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

extension UIImageView
{
    func set(image aImage: UIImage, duration aDuration: TimeInterval)
    {
        UIView.transition(with: self, duration: aDuration, options: UIView.AnimationOptions.transitionCrossDissolve, animations:
        {
            self.image = aImage
        }, completion: nil)
    }
    
    func set(image aImage: UIImage, animate aAnimate: Bool)
    {
        if aAnimate
        {
            self.set(image: aImage, duration: 0.25)
        } else
        {
            self.image = aImage
        }
    }
}
