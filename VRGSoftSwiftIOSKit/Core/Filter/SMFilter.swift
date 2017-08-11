//
//  SMFilter.swift
//  semenag01kit_Swift
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

open class SMFilter: AnyObject
{
    open var maxLengthText:Int = Int.max
    
    init(maxLengthText aMaxLengthText: Int)
    {
        maxLengthText = aMaxLengthText
    }
    
    open func inputField(_ inputField: SMFilterProtocol, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        var result: Bool = true
        
        if text.characters.count > 0
        {
            var charactersCount = 0;
            
            if inputField.filteredText != nil
            {
                charactersCount = (inputField.filteredText! as NSString).replacingCharacters(in: range, with: text).characters.count
            }
            
            result =  charactersCount <= maxLengthText;
        }
        
        return result
    }
}