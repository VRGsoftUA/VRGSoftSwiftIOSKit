//
//  UIView+Help.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

public protocol UIViewLoading { }

public extension UIViewLoading where Self: UIView
{
    public static func loadFromNib(nibNameOrNil: String? = nil) -> Self
    {
        let result: Self = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.last as! Self // swiftlint:disable:this force_cast
        return result
    }
}

extension UIView: UIViewLoading { }


extension UIView
{
    @IBInspectable open var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }

    @IBInspectable open var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
}

extension UIView
{
    open func sm_roundBorder()
    {
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.masksToBounds = true
    }
    
    open func sm_showAnimate(_ aAnimate: Bool)
    {
        if aAnimate
        {
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            }, completion: { finished in
                if finished
                {
                    self.alpha = 1
                }
            })
        } else
        {
            self.alpha = 1
            self.isHidden = false
        }
    }
    
    open func sm_hideAnimate(_ aAnimate: Bool)
    {
        if aAnimate
        {
            UIView.animate(withDuration: 0.2, animations: { 
                self.alpha = 0
            }, completion: { finished in
                if finished
                {
                    self.alpha = 0
                    self.isHidden = true
                }
            })
        } else
        {
            self.alpha = 0
            self.isHidden = true
        }
    }
    
    open var sm_parentViewController: UIViewController?
    {
        var parentResponder: UIResponder? = self
        while parentResponder != nil
        {
            parentResponder = parentResponder?.next
            if let viewController: UIViewController = parentResponder as? UIViewController
            {
                return viewController
            }
        }
        return nil
    }
    
    open func sm_imageCreate() -> UIImage?
    {
        let result: UIImage? = self.layer.sm_imageCreate()
        
        return result
    }
}


extension CALayer
{
    open func sm_imageCreate() -> UIImage?
    {
        var result: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        if let context: CGContext = UIGraphicsGetCurrentContext()
        {
            self.render(in: context)
            result = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return result
    }
}
