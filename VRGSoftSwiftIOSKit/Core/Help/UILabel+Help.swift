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
    func setAtr(interval aInterval: CGFloat)
    {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = aInterval
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        let textAlignment: NSTextAlignment = self.textAlignment
        self.attributedText = attributedString
        self.textAlignment = textAlignment
    }
    
    func setAttributedText(markString: String, markFont: UIFont)
    {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])

        let markAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: markFont]
        if let range = (self.text as NSString?)?.range(of: markString)
        {
           attributedString.addAttributes(markAttribute, range: range)
        }
        self.attributedText = attributedString
    }
    
    func setAttributedText(markString: String, markTextColor: UIColor)
    {
        guard let text = self.text else { return }

        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])
        
        let markAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: markTextColor]
        let range = (text as NSString).range(of: markString)
        attributedString.addAttributes(markAttribute, range: range)
        self.attributedText = attributedString
    }
    
    func setAttributedText(markString: String, markTextColor: UIColor, markFont: UIFont)
    {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: self.font])
        
        let markAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: markTextColor, NSAttributedStringKey.font: markFont]
        let range = (text as NSString).range(of: markString)
        attributedString.addAttributes(markAttribute, range: range)
        self.attributedText = attributedString
    }
}
