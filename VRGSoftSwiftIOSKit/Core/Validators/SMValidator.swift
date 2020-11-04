//
//  SMValidator.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation

public enum SMValidationErrorStrategy: Int {
    case alert, text
}

public protocol SMValidationProtocol: AnyObject {
    
    var validatableText: String? { get set }
    var validator: SMValidator? { get set }
    func validate() -> Bool
}


open class SMValidator {
    
    open var errorMessage: String?
    open var titleMessage: String?
    
    open var needTrimText: Bool = true
    open var isValidIfEmpty: Bool = false
    
    open var errorStrategy: SMValidationErrorStrategy = .text

    public init() { }
    
    open weak var validatableObject: SMValidationProtocol?
    
    open func validate() -> Bool {
        
        trimTextIfNeed()
        
        if isValidIfEmpty && validatableObject?.validatableText?.isEmpty ?? true {
            
            return true
        } else {
            
            return false
        }
    }
    
    open func trimTextIfNeed() {
        
        if needTrimText {
            
            self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
    }
}


open class SMCompoundValidator: SMValidator {
    
    public let validators: [SMValidator]
    open var successIfAtLeastOne: Bool = false
    
    public init(validators aValidators: [SMValidator]) {
        
        validators = aValidators
    }
    
    open override var isValidIfEmpty: Bool {
        
        didSet {
            
            for validator: SMValidator in validators {
                
                validator.isValidIfEmpty = isValidIfEmpty
            }
        }
    }
    
    open override var needTrimText: Bool {
        
        didSet {
            
            for validator: SMValidator in validators {
                
                validator.needTrimText = needTrimText
            }
        }
    }

    override open func validate() -> Bool {
        
        assert(validators.count != 0, "count of validators should be more than 0")
        
        let result: Bool = (self.successIfAtLeastOne) ? false : true
        
        for validator: SMValidator in validators {
            
            validator.validatableObject = self.validatableObject
           
            let valid: Bool = validator.validate()
            
            if valid && self.successIfAtLeastOne {
                
                return true
            } else if !valid && !self.successIfAtLeastOne {
                
                return false
            }
        }
        
        return result
    }
    
    override open var titleMessage: String? {
        
        get {
            if super.titleMessage != nil {
                
                return super.titleMessage
            } else {
                
                return self.firstNotValideValidator?.titleMessage
            }
        }
        
        set {
            super.titleMessage = newValue
        }
    }

    override open var errorMessage: String? {
        
        get {
            if super.errorMessage != nil {
                
                return super.errorMessage
            } else {
                
                return self.firstNotValideValidator?.errorMessage
            }
        }
        
        set {
            super.errorMessage = newValue
        }
    }

    open var firstNotValideValidator: SMValidator? {
        
        var result: SMValidator?
            
        for validator: SMValidator in self.validators {
            
            validator.validatableObject = self.validatableObject
            
            let valid: Bool = validator.validate()
            
            if !valid {
                
                result = validator
                break
            }
        }
        
        return result
    }
}
 
open class SMValidatorAny: SMValidator {
    
    override open func validate() -> Bool {
        
        return true
    }
}

open class SMValidatorIntWithRange: SMValidator {
    
    public let range: NSRange
    public init(range aRange: NSRange) {
        range = aRange
    }
    
    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {
            
            if let validatableText: String = validatableObject?.validatableText,
                let intValue: Int = Int(validatableText) {
                
                result = intValue >= range.location && intValue <= range.location + range.length
            }
        }
        
        return result
    }
}

open class SMValidatorCountNumberInTextWithRange: SMValidator {
    // range.location=startPoint and range.length=endPoint-range.location+1
    open var range: NSRange
    
    public init(range aRange: NSRange) {
        
        range = aRange
    }
    
    override open func validate() -> Bool {
                        
        var result: Bool = super.validate()
        
        if !result {
            
            let count: Int = validatableObject?.validatableText?.count ?? 0
            
            result = NSLocationInRange(count, range)
        }

        return result
    }
}

open class SMValidatorStringWithRange: SMValidator {
    
    open var range: NSRange
    
    public init(range aRange: NSRange) {
        
        range = aRange
    }

    override open func validate() -> Bool {
                
        var result: Bool = super.validate()
        
        if !result {
            
            if let length: Int = self.validatableObject?.validatableText?.count,
                length >= range.location,
                length <= range.length {
                
                result = true
            }
        }

        return result
    }
}

open class SMValidatorEmail: SMValidator {
    
    override open func validate() -> Bool {
                
        var result: Bool = super.validate()
        
        if !result {
                        
            let mailRegExp: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let regExp: NSRegularExpression? = try? NSRegularExpression(pattern: mailRegExp, options: NSRegularExpression.Options.caseInsensitive)
            
            var count: Int = 0
            
            if let validatableText: String = validatableObject?.validatableText,
                let numberOfMatches: Int = regExp?.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: validatableText.count)) {
                
                count = numberOfMatches
            }

            result = count == 1
        }

        return result
    }
}

open class SMValidatorNotEmpty: SMValidator {
    
    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {

            result = self.validatableObject?.validatableText?.count ?? 0 > 0
        }

        return result
    }
}

open class SMValidatorEqual: SMValidator {
    
    public let testedValidator: SMValidator
    open var isIgnoreCase: Bool = false
    
    public init(testedValidator aTestedValidator: SMValidator) {
        
        testedValidator = aTestedValidator
    }

    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {

            if testedValidator.validate() {
                
                if self.isIgnoreCase,
                    let validatableText: String = testedValidator.validatableObject?.validatableText,
                    let result_: ComparisonResult = (self.validatableObject?.validatableText?.compare(validatableText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)) {
                    
                    result = result_ == ComparisonResult.orderedSame
                } else {
                    
                    result = self.validatableObject?.validatableText == testedValidator.validatableObject?.validatableText
                }
            } else {
                
                result = false
            }
        }
        
        return result
    }
}


open class SMValidatorRegExp: SMValidator {
    
    public let regularExpression: NSRegularExpression

    public init(regExp aRegExp: NSRegularExpression) {
        
        regularExpression = aRegExp
    }
    
    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {

            var count: Int = 0

            if let validatableText: String = validatableObject?.validatableText {
                
                count = regularExpression.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: validatableText.count))
            }
            
            result = count == 1
        }

        return result
    }
}


open class SMValidatorUSAZipCode: SMValidator {
    
    override open func validate() -> Bool {
                
        var result: Bool = super.validate()
        
        if !result {
            
            let patern: String = "^[0-9]+$"
            
            let regExp: NSRegularExpression? = try? NSRegularExpression(pattern: patern, options: NSRegularExpression.Options.caseInsensitive)
            
            var count: Int = 0
            
            if let validatableText: String = validatableObject?.validatableText {
                
                if validatableText.count == 5,
                    let numberOfMatches: Int = regExp?.numberOfMatches(in: validatableText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: validatableText.count)) {
                    
                    count = numberOfMatches
                }
            }
            
            result = count == 1
        }

        return result

    }
}

open class SMValidatorLatinicOnly: SMValidator {
    
    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {
            
            if let validetableText: String = validatableObject?.validatableText {
                
                result = validetableText.range(of: "\\P{Latin}", options: .regularExpression) == nil
            }
        }

        return result
    }
}

open class SMValidatorLenghtMoreOrEqualThan: SMValidator {
    
    public let number: Int
    
    public init(aNumber: Int) {
        number = aNumber
        
        super.init()
    }
    
    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {
            
            if let validetableText: String = validatableObject?.validatableText {
                
                result = validetableText.count >= number
            }
        }

        return result
    }
}

open class SMValidatorHasDigit: SMValidator {
    
    override open func validate() -> Bool {
        
        var result: Bool = super.validate()
        
        if !result {
            
            if let validetableText: String = validatableObject?.validatableText {
                
                let decimalCharacters: CharacterSet = CharacterSet.decimalDigits
                
                let decimalRange: Range<String.Index>? = validetableText.rangeOfCharacter(from: decimalCharacters)
                
                result = decimalRange != nil ? true : false
            }
        }

        return result
    }
}
