//
//  NSAttributedString + Help.swift
//  time-capsule-ios
//
//  Created by developer on 7/5/18.
//  Copyright © 2018 OLEKSANDR SEMENIUK. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString
{
    open func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
}
