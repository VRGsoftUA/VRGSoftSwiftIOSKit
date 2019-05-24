//
//  UIButton+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

public extension SMWrapper where Base: UIButton {
    
    func setBackgroundColor(_ aColor: UIColor, for aState: UIControl.State) {
        
        base.setBackgroundImage(UIImage.sm.resizableImageWith(color: aColor), for: aState)
    }
}
