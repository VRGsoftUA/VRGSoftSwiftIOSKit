//
//  SMToolbar.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/11/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMToolbar: UIToolbar {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }

    open func setup() {
        
    }
}
