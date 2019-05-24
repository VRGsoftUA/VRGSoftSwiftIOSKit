//
//  UIView+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UIView {
    
    static func loadFromNib(nibNameOrNil: String? = nil) -> Base {
        
        let result: Base = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.last as! Base // swiftlint:disable:this force_cast
        return result
    }
    
    func roundBorder() {
        
        base.layer.cornerRadius = base.frame.size.height/2.0
        base.layer.masksToBounds = true
    }
    
    func showAnimate(_ aAnimate: Bool) {
        
        if aAnimate {
            
            base.isHidden = false
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.base.alpha = 1
            }, completion: { finished in
                
                if finished {
                    
                    self.base.alpha = 1
                }
            })
        } else {
            base.alpha = 1
            base.isHidden = false
        }
    }
    
    func hideAnimate(_ aAnimate: Bool) {
        
        if aAnimate {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.base.alpha = 0
            }, completion: { finished in
                
                if finished {
                    
                    self.base.alpha = 0
                    self.base.isHidden = true
                }
            })
        } else {
            
            base.alpha = 0
            base.isHidden = true
        }
    }
    
    var parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = base
        
        while parentResponder != nil {
            
            parentResponder = parentResponder?.next
            
            if let viewController: UIViewController = parentResponder as? UIViewController {
                
                return viewController
            }
        }
        
        return nil
    }
    
    func imageCreate() -> UIImage? {
        
        let result: UIImage? = base.layer.sm.imageCreate()
        
        return result
    }
}


extension UIView: SMCompatible { }
