//
//  UIView+PSSizes.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/14/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UIView {
    
    var left: CGFloat {
        
        get {
            return base.frame.origin.x
        }
        set(left) {
            var frame: CGRect = base.frame
            frame.origin.x = left
            base.frame = frame
        }
    }
    
    var top: CGFloat {
        
        get {
            return base.frame.origin.y
        }
        set(top) {
            var frame: CGRect = base.frame
            frame.origin.y = top
            base.frame = frame
        }
    }
    
    var right: CGFloat {
        
        get {
            return base.frame.origin.x + base.frame.size.width
        }
        set(right) {
            var frame: CGRect = base.frame
            frame.origin.x = right - frame.size.width
            base.frame = frame
        }
    }
    
    var bottom: CGFloat {
        
        get {
            return base.frame.origin.y + base.frame.size.height
        }
        set(bottom) {
            var frame: CGRect = base.frame
            frame.origin.y = bottom - frame.size.height
            base.frame = frame
        }
    }
    
    var width: CGFloat {
        
        get {
            return base.frame.size.width
        }
        set(width) {
            var frame: CGRect = base.frame
            frame.size.width = width
            base.frame = frame
        }
    }
    
    var height: CGFloat {
        
        get {
            return base.frame.size.height
        }
        set(height) {
            var frame: CGRect = base.frame
            frame.size.height = height
            base.frame = frame
        }
    }
    
    var origin: CGPoint {
        
        get {
            return base.frame.origin
        }
        set(origin) {
            var frame: CGRect = base.frame
            frame.origin = origin
            base.frame = frame
        }
    }
    
    var size: CGSize {
        
        get {
            return base.frame.size
        }
        set(size) {
            var frame: CGRect = base.frame
            frame.size = size
            base.frame = frame
        }
    }
    
    var rightMargin: CGFloat {
        
        get {
            if let sWidth: CGFloat = base.superview?.sm.width {
                
                return sWidth - base.frame.size.width - base.frame.origin.x
            } else {
                
                return 0
            }
            
        }
        set(rightMargin) {
            
            if let sWidth: CGFloat = base.superview?.frame.size.width {
                
                var frame: CGRect = base.frame
                frame.origin.x = sWidth - rightMargin - frame.size.width
                base.frame = frame
            }
        }
    }
    
    var bottomMargin: CGFloat {
        
        get {
            if let sHeight: CGFloat = base.superview?.sm.height {
                return sHeight - base.frame.size.height - base.frame.origin.y
            } else {
                return 0
            }
        }
        set(bottomMargin) {
            
            if let sHeight: CGFloat = base.superview?.frame.size.height {
                
                var frame: CGRect = base.frame
                frame.origin.y = sHeight - bottomMargin - frame.size.height
                base.frame = frame
            }
        }
    }
    
    func updateConstrainIfExist(height aHeight: CGFloat) {
        
        for constraint: NSLayoutConstraint in base.constraints where constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
            
            constraint.constant = aHeight
            break
        }
    }
    
    func updateConstrainIfExist(width aWidth: CGFloat) {
        
        for constraint: NSLayoutConstraint in base.constraints where constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
            
            constraint.constant = aWidth
            break
        }
    }
}
