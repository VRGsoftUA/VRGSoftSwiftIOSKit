//
//  String + Help.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 6/22/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
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
        let constraintSize: CGSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func attributedStringWithInterval(aInterval: CGFloat, aFont: UIFont) -> NSAttributedString
    {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = aInterval
        
        let fontAttribute: [NSAttributedString.Key: UIFont] = [NSAttributedString.Key.font: aFont]
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}
