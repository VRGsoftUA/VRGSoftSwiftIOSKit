//
//  SMLabel.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit


open class SMLabel: UILabel {
    
    @IBInspectable open var topT: CGFloat = 0.0
    @IBInspectable open var leftT: CGFloat = 0.0
    @IBInspectable open var bottomT: CGFloat = 0.0
    @IBInspectable open var rightT: CGFloat = 0.0

    override open func draw(_ rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: topT, left: leftT, bottom: bottomT, right: rightT)))
    }
    
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        var rect: CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= leftT
        rect.origin.y -= rightT
        rect.size.width += (leftT + rightT)
        rect.size.height += (topT + bottomT)
        
        return rect
    }
}
