//
//  SMHelper.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMHelper: Any
{
    
    open static var isIPad: Bool
    {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

}
