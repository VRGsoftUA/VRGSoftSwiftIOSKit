//
//  SMFormatter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/19/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public protocol SMFormatterProtocol: AnyObject {
    
    var formatter: SMFormatter? { get set }
    var formattingText: String? { get set }
}

open class SMFormatter {
    
    weak open var formattableObject: SMFormatterProtocol?
    
    public init() {
        
    }
    
    open func formattedTextFrom(originalString aOriginalString: String?) -> String? {
        
        return aOriginalString
    }
    
    open func formatWithNewCharactersIn(range aRange: NSRange, replacementString aString: String) -> Bool {
        
        return true
    }
    
    open var rawText: String? {
        
        get {
            return nil
        }
        set {
            self.formattableObject?.formattingText = self.formattedTextFrom(originalString: newValue)
        }
    }
}
