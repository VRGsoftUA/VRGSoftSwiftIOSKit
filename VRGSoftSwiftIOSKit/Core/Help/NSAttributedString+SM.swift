//
//  NSAttributedString+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 7/5/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: NSAttributedString {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintSize: CGSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox: CGRect = base.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
}


extension NSAttributedString: SMCompatible { }
