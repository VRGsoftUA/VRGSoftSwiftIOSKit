//
//  SMHelper.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMHelper: Any {
    
    public static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

}
