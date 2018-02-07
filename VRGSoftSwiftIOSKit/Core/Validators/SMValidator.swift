//
//  SMValidator.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation

public protocol SMValidationProtocol: AnyObject
{
    var validatableText: String? { get set }
    var validator: SMValidator? { get set }
    func validate() -> Bool
}


open class SMValidator
{
    open var _errorMessage: String?
    open var errorMessage: String?
    {
        get
        {
            return _errorMessage
        }
        set
        {
            _errorMessage = newValue
        }
    }
    
    open var _titleMessage: String?
    open var titleMessage: String?
    {
        get
        {
            return _titleMessage
        }
        set
        {
            _titleMessage = newValue
        }
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
            if _titleMessage != nil
            {
                return _titleMessage
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
            if _errorMessage != nil
            {
                return _errorMessage
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

    open var firstNotValideValidator:SMValidator?
    {
        get
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
    var range: NSRange?
    public init(range aRange: NSRange)
    {
        super.init()
        range = aRange
    }
    
    override open func validate() -> Bool
    {
        var result: Bool = false
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let intValue: Int = Int(self.validatableObject!.validatableText!)!
        
        result = intValue >= range!.location && intValue <= range!.location + range!.length
        
        return result
    }
}

open class SMValidatorCountNumberInTextWithRange: SMValidator
{
    var range: NSRange?
    public init(range aRange: NSRange)
    {
        super.init()
        range = aRange
    }
    
    override open func validate() -> Bool
    {
        let result: Bool = false
        assert(result)
        return result
    }
}

open class SMValidatorStringWithRange: SMValidator
{
    var range: NSRange?
    public init(range aRange: NSRange)
    {
        super.init()
        range = aRange
    }

    override open func validate() -> Bool
    {
        var result: Bool = false
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        let length: Int = (self.validatableObject?.validatableText?.count)!
        
        if length >= range!.location && length <= range!.length
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
        
        let mailRegExp: String! = "^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$"
        
        let regExp: NSRegularExpression = try! NSRegularExpression(pattern: mailRegExp, options: NSRegularExpression.Options.caseInsensitive)
        
        var count: Int = 0
        
        if let validatableText = validatableObject?.validatableText
        {
            count = regExp.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, validatableText.count))
        }

        
        return count == 1
    }
}


open class SMValidatorNotEmpty: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        return (self.validatableObject!.validatableText?.count)! > 0
    }
}


open class SMValidatorEqual: SMValidator
{
    let testedValidator: SMValidator
    var isIgnoreCase: Bool
    
    
    public init(testedFieldValidator aTestedObject: SMValidationProtocol)
    {
        testedValidator = aTestedObject.validator!
        isIgnoreCase = false
    }

    public init(testedValidator aTestedValidator: SMValidator)
    {
        testedValidator = aTestedValidator
        isIgnoreCase = false
    }

    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if self.isIgnoreCase
        {
            let result: ComparisonResult! = (self.validatableObject?.validatableText?.compare(testedValidator.validatableObject!.validatableText!, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil))
            
            return result == ComparisonResult.orderedSame
        } else
        {
            return self.validatableObject?.validatableText == testedValidator.validatableObject?.validatableText
        }
    }
}


open class SMValidatorRegExp: SMValidator
{
    let regularExpression: NSRegularExpression!

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
            count = regularExpression.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, validatableText.count))
        }
        
        return count == 1
    }
}


open class SMValidatorUSAZipCode: SMValidator
{
    override open func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let patern: String! = "^[0-9]+$"
        
        let regExp: NSRegularExpression = try! NSRegularExpression(pattern: patern, options: NSRegularExpression.Options.caseInsensitive)
        
        var count: Int = 0
        
        if let validatableText = validatableObject?.validatableText && validatableText.count == 5
        {
            count = regExp.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, validatableText.count))
        }
        
        return count == 1
    }
}
