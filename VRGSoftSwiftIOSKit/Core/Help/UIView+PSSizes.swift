//
//  UIView+PSSizes.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/14/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension UIView {
    
    var left: CGFloat {
        
        get {
            return frame.origin.x
        }
        set(left) {
            var frame: CGRect = self.frame
            frame.origin.x = left
            self.frame = frame
        }
    }
    
    var top: CGFloat {
        
        get {
            return frame.origin.y
        }
        set(top) {
            var frame: CGRect = self.frame
            frame.origin.y = top
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        
        get {
            return frame.origin.x + frame.size.width
        }
        set(right) {
            var frame: CGRect = self.frame
            frame.origin.x = right - frame.size.width
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        
        get {
            return frame.origin.y + frame.size.height
        }
        set(bottom) {
            var frame: CGRect = self.frame
            frame.origin.y = bottom - frame.size.height
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        
        get {
            return frame.size.width
        }
        set(width) {
            var frame: CGRect = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        
        get {
            return frame.size.height
        }
        set(height) {
            var frame: CGRect = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        
        get {
            return frame.origin
        }
        set(origin) {
            var frame: CGRect = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
    var size: CGSize {
        
        get {
            return frame.size
        }
        set(size) {
            var frame: CGRect = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    var rightMargin: CGFloat {
        
        get {
            if let sWidth: CGFloat = superview?.width {
                
                return sWidth - frame.size.width - frame.origin.x
            } else {
                
                return 0
            }
            
        }
        set(rightMargin) {
            
            if let sWidth: CGFloat = superview?.frame.size.width {
                
                var frame: CGRect = self.frame
                frame.origin.x = sWidth - rightMargin - frame.size.width
                self.frame = frame
            }
        }
    }
    
    var bottomMargin: CGFloat {
        
        get {
            if let sHeight: CGFloat = superview?.height {
                return sHeight - frame.size.height - frame.origin.y
            } else {
                return 0
            }
        }
        set(bottomMargin) {
            
            if let sHeight: CGFloat = superview?.frame.size.height {
                
                var frame: CGRect = self.frame
                frame.origin.y = sHeight - bottomMargin - frame.size.height
                self.frame = frame
            }
        }
    }
}
