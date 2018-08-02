//
//  SMFilter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 7/17/17.
//  Copyright © 2017 semenag01. All rights reserved.
//

import Foundation
import UIKit

public protocol SMFilterProtocol
{
    var filteredText: String? { get }
}

open class SMFilter
{
    open var maxLengthText: Int = Int.max
    
    public init(maxLengthText aMaxLengthText: Int)
    {
        maxLengthText = aMaxLengthText
    }
    
    open func inputField(_ inputField: SMFilterProtocol, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        var result: Bool = true
        
        if text.count > 0
        {
            var charactersCount: Int = 0
            
            if let filteredText: String = inputField.filteredText
            {
                charactersCount = (filteredText as NSString).replacingCharacters(in: range, with: text).count
            }
            
            result =  charactersCount <= maxLengthText
        }
        
        return result
    }
}
