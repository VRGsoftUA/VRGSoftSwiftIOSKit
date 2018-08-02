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
        let constraintSize: CGSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
}
