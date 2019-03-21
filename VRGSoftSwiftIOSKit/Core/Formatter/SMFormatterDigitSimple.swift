//
//  SMFormatterDigitSimple.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 9/3/18.
//  Copyright © 2018 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMFormatterDigitSimple: SMFormatter {
    
    public let formaters: [String]
    public let acceptableInputCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789")
    
    open var isAcceptsNotPredefinedFormatter: Bool = false
    
    public init(formaters aFormaters: [String]) {
        
        formaters = aFormaters
        super.init()
    }
    
    override open func formatWithNewCharactersIn(range aRange: NSRange, replacementString aString: String) -> Bool {
        
        if let textField: UITextField = self.formattableObject as? UITextField {
            return format(forTextField: textField, shouldChangeCharactersInRange: aRange, replacementString: aString)
        }
        
        return true
    }
    
    open func format(forTextField aTextField: UITextField, shouldChangeCharactersInRange aRange: NSRange, replacementString aString: String) -> Bool {
        
        let result: Bool = false
        
        if aString.count > 0 {
            
            if aString.rangeOfCharacter(from: acceptableInputCharacters) != nil {
                
                var newText: String? = (aTextField.text as NSString?)?.replacingCharacters(in: aRange, with: aString)
                
                if let text: String = newText {
                    newText = format(text: text)
                }
                
                if newText != nil {
                    aTextField.text = newText
                }
            }
        } else {
            var newText: String? = (aTextField.text as NSString?)?.replacingCharacters(in: aRange, with: aString)
            
            if let text: String = newText {
                newText = format(text: text)
            }
            
            if newText != nil {
                aTextField.text = newText
            }
        }
        
        return result
    }
    
    open func formattedStringFormString(originalStr aOriginalStr: String) -> String {
        
        var result: String = aOriginalStr
        
        if let str: String = format(text: aOriginalStr) {
            result = str
        }
        
        return result
    }
    
    open func format(text aText: String) -> String? {
        
        let input: String =  strip(text: aText)
        
        for format: String in formaters {
            
            var inputIndex: Int = 0
            var formatIndex: Int = 0
            var temp: NSMutableString? = NSMutableString()
            
            while temp != nil && inputIndex < input.count && formatIndex < format.count {
                
                let formatChar: Character = format[String.Index(encodedOffset: formatIndex)]
                let isRequred: Bool = canBeInputtedByPhonePad(char: formatChar)
                let nextInputChar: Character = input[String.Index(encodedOffset: inputIndex)]
                
                switch formatChar {
                case "#":
                    if nextInputChar < "0" || nextInputChar > "9" {
                        temp = nil
                    }
                    temp?.append(String(nextInputChar))
                    inputIndex += 1
                default:
                    if isRequred {
                        
                        if nextInputChar != formatChar {
                            temp = nil
                        }
                        
                        temp?.append(String(nextInputChar))
                        inputIndex += 1
                    } else {
                        temp?.append(String(formatChar))
                        if nextInputChar == formatChar {
                            inputIndex += 1
                        }
                    }
                }
                
                formatIndex += 1
            }
            
            
            if inputIndex == input.count {
                return temp as String?
            }
        }
        
        if isAcceptsNotPredefinedFormatter {
            return input
        } else {
            return nil
        }
    }
    
    open func strip(text aText: String) -> String {
        
        let result: NSMutableString = NSMutableString()
        
        for index: Int in 0..<aText.count {
            
            if canBeInputtedByPhonePad(char: aText[String.Index(encodedOffset: index)]) {
                result.append(String(aText[String.Index(encodedOffset: index)]))
            }
        }
        
        return result as String
    }
    
    open func canBeInputtedByPhonePad(char aChar: Character) -> Bool {
        
        let tempStr: String = String(aChar)
        let tempSet: CharacterSet = CharacterSet(charactersIn: tempStr)
        
        let result: Bool = acceptableInputCharacters.isSuperset(of: tempSet)
        
        return result
    }
    
    private func rangeFromNSRange(nsRange: NSRange, string aStr: String) -> Range<String.Index>? {
        return Range(nsRange, in: aStr)
    }
}
