//
//  SMValidator.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation

public enum SMValidationErrorStrategy: Int
{
    case alert, text
}

public protocol SMValidationProtocol: AnyObject
{
    var validatableText: String? { get set }
    var validator: SMValidator? { get set }
    func validate() -> Bool
}


open class SMValidator
{
    open var errorMessage: String?
    open var titleMessage: String?
    
    open var errorStrategy: SMValidationErrorStrategy = .text

    public init()
    {
        
    }
    
    open weak var validatableObject: SMValidationProtocol?
    
    open func validate() -> Bool
    {
        return false
    }
}


open class SMCompoundValidator: SMValidator
{
    open let validators: [SMValidator]
    open var successIfAtLeastOne: Bool = false
    
    public init(validators aValidators: [SMValidator])
    {
        validators = aValidators
    }
    
    override open func validate() -> Bool
    {
        assert(validators.count != 0, "count of validators should be more than 0")
        
        let result: Bool = (self.successIfAtLeastOne) ? false : true
        
        for validator: SMValidator in validators
        {
            validator.validatableObject = self.validatableObject
           
            let valid: Bool = validator.validate()
            
            if valid && self.successIfAtLeastOne
            {
                return true
            } else if !valid && !self.successIfAtLeastOne
            {
                return false
            }
        }
        
        return result
    }
    
    override open var titleMessage: String?
    {
        get
        {
            if super.titleMessage != nil
            {
                return super.titleMessage
            } else
            {
                return self.firstNotValideValidator?.titleMessage
            }
        }
        
        set
        {
            super.titleMessage = newValue
        }
    }

    override open var errorMessage: String?
    {
        get
        {
            if super.errorMessage != nil
            {
                return super.errorMessage
            } else
            {
                return self.firstNotValideValidator?.errorMessage
            }
        }
        
        set
        {
            super.errorMessage = newValue
        }
    }

    open var firstNotValideValidator: SMValidator?
    {
        var result: SMValidator?
            
        for validator: SMValidator in self.validators
        {
            validator.validatableObject = self.validatableObject
            
            let valid: Bool = validator.validate()
            
            if !valid
            {
                result = validator
                break
            }
        }
        
        return result
    }
}
 
open class SMValidatorAny: SMValidator
{
    override open func validate() -> Bool
    {
        return true
    }
}

open class SMValidatorIntWithRange: SMValidator
{
    open let range: NSRange
    public init(range aRange: NSRange)
    {
        range = aRange
    }
    
    override open func validate() -> Bool
    {
        var result: Bool = false
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if let validatableText = validatableObject?.validatableText,
            let intValue: Int = Int(validatableText)
        {
            result = intValue >= range.location && intValue <= range.location + range.length
        }
        return result
    }
}

open class SMValidatorCountNumberInTextWithRange: SMValidator
{
    // range.location=startPoint and range.length=endPoint-range.location+1
    open var range: NSRange
    public init(range aRange: NSRange)
    {
        range = aRange
    }
    
    override open func validate() -> Bool
    {
        var result: Bool = false
        
        if let count = validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespaces).count
        {
            result = NSLocationInRange(count, range)
        }
        
        return result
    }
}

open class SMValidatorStringWithRange: SMValidator
{
    open var range: NSRange
    public init(range aRange: NSRange)
    {
        range = aRange
    }

    override open func validate() -> Bool
    {
        var result: Bool = false
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if let length: Int = self.validatableObject?.validatableText?.count,
            length >= range.location,
            length <= range.length
        {
            result = true
        }
        
        return result
    }
}

open class SMValidatorEmail: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let mailRegExp: String = "^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$"
        
        let regExp: NSRegularExpression? = try? NSRegularExpression(pattern: mailRegExp, options: NSRegularExpression.Options.caseInsensitive)
        
        var count: Int = 0
        
        if let validatableText = validatableObject?.validatableText,
            let numberOfMatches = regExp?.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: validatableText.count))
        {
            count = numberOfMatches
        }

        return count == 1
    }
}


open class SMValidatorNotEmpty: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        return self.validatableObject?.validatableText?.count ?? 0 > 0
    }
}


open class SMValidatorEqual: SMValidator
{
    open let testedValidator: SMValidator
    open var isIgnoreCase: Bool = false
    
    public init(testedValidator aTestedValidator: SMValidator)
    {
        testedValidator = aTestedValidator
    }

    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if testedValidator.validate()
        {
            if self.isIgnoreCase,
                let validatableText = testedValidator.validatableObject?.validatableText,
                let result: ComparisonResult = (self.validatableObject?.validatableText?.compare(validatableText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil))
            {
                return result == ComparisonResult.orderedSame
            } else
            {
                return self.validatableObject?.validatableText == testedValidator.validatableObject?.validatableText
            }
        } else
        {
            return false
        }
    }
}


open class SMValidatorRegExp: SMValidator
{
    open let regularExpression: NSRegularExpression

    public init(regExp aRegExp: NSRegularExpression)
    {
        regularExpression = aRegExp
    }
    
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        var count: Int = 0

        if let validatableText = validatableObject?.validatableText
        {
            count = regularExpression.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: validatableText.count))
        }
        
        return count == 1
    }
}


open class SMValidatorUSAZipCode: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let patern: String = "^[0-9]+$"
        
        let regExp: NSRegularExpression? = try? NSRegularExpression(pattern: patern, options: NSRegularExpression.Options.caseInsensitive)
        
        var count: Int = 0
        
        if let validatableText = validatableObject?.validatableText
        {
            if validatableText.count == 5,
                let numberOfMatches = regExp?.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: validatableText.count))
            {
                count = numberOfMatches
            }
        }
        
        return count == 1
    }
}

open class SMValidatorLatinicOnly: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if let validetableText = validatableObject?.validatableText
        {
            return validetableText.range(of: "\\P{Latin}", options: .regularExpression) == nil
        }
        
        return false
    }
}

open class SMValidatorLenghtMoreOrEqualThan: SMValidator
{
    open let number: Int
    
    public init(aNumber: Int)
    {
        number = aNumber
        
        super.init()
    }
    
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if let validetableText = validatableObject?.validatableText
        {
            return validetableText.count >= number
        }
        
        return false
    }
}

open class SMValidatorHasDigit: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if let validetableText = validatableObject?.validatableText
        {
            let decimalCharacters = CharacterSet.decimalDigits
            
            let decimalRange = validetableText.rangeOfCharacter(from: decimalCharacters)
            
            return decimalRange != nil ? true : false
        }
        
        return false
    }
}
