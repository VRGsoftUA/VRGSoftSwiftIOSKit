//
//  UILabel+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/27/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UILabel {
    
    func setAtr(interval aInterval: CGFloat) {
        
        guard let text: String = base.text else { return }
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = aInterval
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        let textAlignment: NSTextAlignment = base.textAlignment
        base.attributedText = attributedString
        base.textAlignment = textAlignment
    }
    
    func setAttributedText(markString: String, markFont: UIFont) {
        
        if let text: String = base.text, let font: UIFont = base.font {
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
            
            let markAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: markFont]
            
            if let range: NSRange = (base.text as NSString?)?.range(of: markString) {
                attributedString.addAttributes(markAttribute, range: range)
            }
            
            base.attributedText = attributedString
        }
    }
    
    func setAttributedText(markString: String, markTextColor: UIColor) {
        
        if let text: String = base.text, let font: UIFont = base.font {

            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
            
            let markAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: markTextColor]
            let range: NSRange = (text as NSString).range(of: markString)
            attributedString.addAttributes(markAttribute, range: range)
            base.attributedText = attributedString
        }
    }
    
    func setAttributedText(markString: String, markTextColor: UIColor, markFont: UIFont) {
        
        if let text: String = base.text, let font: UIFont = base.font {

            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
            
            let markAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: markTextColor, NSAttributedString.Key.font: markFont]
            let range: NSRange = (text as NSString).range(of: markString)
            attributedString.addAttributes(markAttribute, range: range)
            base.attributedText = attributedString
        }
    }
    
    func setAtrUnderLine() {
        
        if let text: String = base.text, let font: UIFont = base.font {

            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
            base.attributedText = attributedString
        }
    }
}
