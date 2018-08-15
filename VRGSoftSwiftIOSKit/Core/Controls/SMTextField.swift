//
//  SMTextField.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

open class SMTextField: UITextField, SMKeyboardAvoiderProtocol, SMValidationProtocol, SMFormatterProtocol, SMFilterProtocol
{
    open weak var smdelegate: UITextFieldDelegate?
    
    open var topT: CGFloat = 0.0
    open var leftT: CGFloat = 0.0
    open var bottomT: CGFloat = 0.0
    open var rightT: CGFloat = 0.0


    // MARK: - Override
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect
    {
        let rect: CGRect = super.textRect(forBounds: bounds)
        
        let result: CGRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: topT, left: leftT, bottom: bottomT, right: rightT))
        
        return result
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        let rect: CGRect =  super.editingRect(forBounds: bounds)
        
        let result: CGRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: topT, left: leftT, bottom: bottomT, right: rightT))
        
        return result
    }
    
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect
//    {
//        let rect: CGRect =  super.placeholderRect(forBounds: bounds)
//        
//        let result: CGRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topT, left, bottomT, rightT))
//        
//        return result
//    }

    
    // MARK: - SMFilterProtocol
    
    open var filteredText: String? {get {return self.text}}
    
    open var filter: SMFilter?
    
    
    open var delegateHolder: SMTextFieldDelegateHolder?
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    open func setup()
    {
        delegateHolder = SMTextFieldDelegateHolder(textField: self)
        super.delegate = delegateHolder
    }
    
    
    // MARK: - SMValidationProtocol
    
    open var validatableText: String?
    {
        get
        {
            return self.text
        }
        set
        {
            self.text = newValue
        }
    }
    
    open var validator: SMValidator?
    {
        didSet
        {
            validator?.validatableObject = self
        }
    }
    
    open func validate() -> Bool
    {
        return validator?.validate() ?? true
    }
    
    open var placeholderColor: UIColor?
    {
        didSet
        {
            if let placeholder: String = placeholder, let placeholderColor: UIColor = placeholderColor
            {
                let atrPlaceholder: NSAttributedString = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor as Any])
                self.attributedPlaceholder = atrPlaceholder
            }
        }
    }
    
    override open var placeholder: String?
    {
        didSet
        {
            if let placeholderColor: UIColor = self.placeholderColor
            {
                self.placeholderColor = placeholderColor
            }
        }
    }

    
    // MARK: - SMFormatterProtocol

    public var formatter: SMFormatter?
    {
        didSet
        {
            formatter?.formattableObject = self
        }
    }
    
    public var formattingText: String?
    {
        get
        {
            return self.text
        }
        
        set
        {
            self.text = newValue
        }
    }
    
    
    // MARK: - SMKeyboardAvoiderProtocol
    
    public weak var keyboardAvoiding: SMKeyboardAvoidingProtocol?
}


// MARK: - SMTextFieldDelegateHolder

open class SMTextFieldDelegateHolder: NSObject, UITextFieldDelegate
{
    weak var holdedTextField: SMTextField?
    
    required public init(textField aTextField: SMTextField)
    {
        holdedTextField = aTextField
    }
    
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return holdedTextField?.smdelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        holdedTextField?.keyboardAvoiding?.adjustOffset()

        holdedTextField?.smdelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        return holdedTextField?.smdelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        holdedTextField?.smdelegate?.textFieldDidEndEditing?(textField)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    {
        holdedTextField?.smdelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var result: Bool = true
        
        if let inputField: SMTextField = textField as? SMTextField
        {
            result = inputField.filter?.inputField(inputField, shouldChangeTextIn: range, replacementText: string) ?? result
        }
                
        if result
        {
            result = holdedTextField?.formatter?.formatWithNewCharactersIn(range: range, replacementString: string) ?? result
        }

        if result
        {
            result = holdedTextField?.smdelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? result
        }
        
        return result
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        let result: Bool = holdedTextField?.smdelegate?.textFieldShouldClear?(textField) ?? true
        return result
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let result: Bool = holdedTextField?.smdelegate?.textFieldShouldReturn?(textField) ?? true
        
        if result
        {
            holdedTextField?.keyboardAvoiding?.responderShouldReturn(textField)
        }
        
        return result
    }
}
