//
//  UILabel+Help.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/27/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

extension UILabel
{
    open func setAtr(interval aInterval: CGFloat)
    {
        guard let text: String = self.text else { return }
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = aInterval
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        let textAlignment: NSTextAlignment = self.textAlignment
        self.attributedText = attributedString
        self.textAlignment = textAlignment
    }
    
    open func setAttributedText(markString: String, markFont: UIFont)
    {
        guard let text: String = self.text else { return }
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])

        let markAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: markFont]
        if let range: NSRange = (self.text as NSString?)?.range(of: markString)
        {
           attributedString.addAttributes(markAttribute, range: range)
        }
        self.attributedText = attributedString
    }
    
    open func setAttributedText(markString: String, markTextColor: UIColor)
    {
        guard let text: String = self.text else { return }

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])
        
        let markAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: markTextColor]
        let range: NSRange = (text as NSString).range(of: markString)
        attributedString.addAttributes(markAttribute, range: range)
        self.attributedText = attributedString
    }
    
    open func setAttributedText(markString: String, markTextColor: UIColor, markFont: UIFont)
    {
        guard let text: String = self.text else { return }
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])
        
        let markAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: markTextColor, NSAttributedStringKey.font: markFont]
        let range: NSRange = (text as NSString).range(of: markString)
        attributedString.addAttributes(markAttribute, range: range)
        self.attributedText = attributedString
    }
    
    open func setAtrUnderLine()
    {
        guard let text: String = self.text else { return }
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
