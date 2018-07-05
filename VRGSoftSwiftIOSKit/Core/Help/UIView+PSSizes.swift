//
//  UIView+PSSizes.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/14/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

extension UIView
{
    open var left: CGFloat
    {
        get
        {
            return self.frame.origin.x
        }
        set(left)
        {
            var frame: CGRect = self.frame
            frame.origin.x = left
            self.frame = frame
        }
    }
    
    open var top: CGFloat
    {
        get
        {
            return self.frame.origin.y
        }
        set(top)
        {
            var frame: CGRect = self.frame
            frame.origin.y = top
            self.frame = frame
        }
    }

    open var right: CGFloat
    {
        get
        {
            return self.frame.origin.x + self.frame.size.width
        }
        set(right)
        {
            var frame: CGRect = self.frame
            frame.origin.x = right - frame.size.width
            self.frame = frame
        }
    }
    
    open var bottom: CGFloat
    {
        get
        {
            return self.frame.origin.y + self.frame.size.height
        }
        set(bottom)
        {
            var frame: CGRect = self.frame
            frame.origin.y = bottom - frame.size.height
            self.frame = frame
        }
    }
    
    open var width: CGFloat
    {
        get
        {
            return self.frame.size.width
        }
        set(width)
        {
            var frame: CGRect = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }

    open var height: CGFloat
    {
        get
        {
            return self.frame.size.height
        }
        set(height)
        {
            var frame: CGRect = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }

    open var origin: CGPoint
    {
        get
        {
            return self.frame.origin
        }
        set(origin)
        {
            var frame: CGRect = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }

    open var size: CGSize
    {
        get
        {
            return self.frame.size
        }
        set(size)
        {
            var frame: CGRect = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    open var rightMargin: CGFloat
    {
        get
        {
            if let sWidth: CGFloat = superview?.width
            {
                return sWidth - frame.size.width - frame.origin.x
            } else
            {
                return 0
            }
            
        }
        set(rightMargin)
        {
            if let sWidth: CGFloat = superview?.frame.size.width
            {
                var frame: CGRect = self.frame
                frame.origin.x = sWidth - rightMargin - frame.size.width
                self.frame = frame
            }
        }
    }
    
    open var bottomMargin: CGFloat
    {
        get
        {
            if let sHeight: CGFloat = superview?.height
            {
                return sHeight - frame.size.height - frame.origin.y
            } else
            {
                return 0
            }
        }
        set(bottomMargin)
        {
            if let sHeight: CGFloat = superview?.frame.size.height
            {
                var frame: CGRect = self.frame
                frame.origin.y = sHeight - bottomMargin - frame.size.height
                self.frame = frame
            }
        }
    }
    
    func sm_updateConstrainIfExist(height aHeight: CGFloat)
    {
        for constraint in self.constraints where constraint.firstAttribute == NSLayoutAttribute.height
        {
            constraint.constant = aHeight
            break
        }
    }

    func sm_updateConstrainIfExist(width aWidth: CGFloat)
    {
        for constraint in self.constraints where constraint.firstAttribute == NSLayoutAttribute.width
        {
            constraint.constant = aWidth
            break
        }
    }
}
