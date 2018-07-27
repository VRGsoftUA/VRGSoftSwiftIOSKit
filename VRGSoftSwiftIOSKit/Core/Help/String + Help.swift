//
//  String + Help.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 6/22/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    public func localize() -> String
    {
        return NSLocalizedString(self, comment: "")
    }
    
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func attributedStringWithInterval(aInterval: CGFloat, aFont: UIFont) -> NSAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = aInterval
        
        let fontAttribute = [NSAttributedStringKey.font: aFont]
        
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}
