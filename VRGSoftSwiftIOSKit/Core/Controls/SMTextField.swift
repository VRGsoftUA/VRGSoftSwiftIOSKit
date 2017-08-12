//
//  SMTextField.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

open class SMTextField: UITextField, SMKeyboardAvoiderProtocol, SMValidationProtocol, SMFormatterProtocol, SMFilterProtocol
{
    // MARK: - SMFilterProtocol
    
    open var filteredText: String? {get {return self.text}}
    
    open var filter: SMFilter?
    
    open var smdelegate: UITextFieldDelegate?
    
    open var delegateHolder: SMTextFieldDelegateHolder?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    open func setup() -> Void
    {
        delegateHolder = SMTextFieldDelegateHolder(textField: self)
        self.delegate = delegateHolder
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
            if validator != nil
            {
                validator!.validatableObject = self
            }
        }
    }
    
    open func validate() -> Bool
    {
        return ((validator) != nil) ? validator!.validate() : true
    }
    
    open var placeholderColor: UIColor?
    {
        didSet
        {
            if self.placeholder != nil && placeholderColor != nil
            {
                let atrPlaceholder: NSAttributedString = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: placeholderColor as Any])
                self.attributedPlaceholder = atrPlaceholder
            }
        }
    }
    
    override open var placeholder: String?
    {
        didSet
        {
            if let placeholderColor = self.placeholderColor
            {
                self.placeholderColor = placeholderColor
            }
        }
    }

    
    // MARK: - SMFormatterProtocol

    var formatter: SMFormatter?
    {
        didSet
        {
            if formatter != nil
            {
                formatter!.formattableObject = self
            }
        }
    }
    
    var formattingText: String?
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
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldShouldBeginEditing(_:) != nil
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldBeginEditing!(textField)
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if self.holdedTextField != nil && self.holdedTextField!.keyboardAvoiding != nil
        {
            self.holdedTextField!.keyboardAvoiding!.adjustOffset()
        }

        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldDidBeginEditing(_:) != nil
        {
            self.holdedTextField!.smdelegate!.textFieldDidBeginEditing!(textField)
        }
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldShouldEndEditing(_:) != nil
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldEndEditing!(textField)
        }
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldDidEndEditing(_:) != nil
        {
            self.holdedTextField!.smdelegate!.textFieldDidEndEditing!(textField)
        }
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldDidEndEditing(_:reason:) != nil
        {
            self.holdedTextField!.smdelegate!.textFieldDidEndEditing!(textField, reason: reason)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var result: Bool = true
        
        let inputField = textField as! SMTextField
        
        if inputField.filter != nil
        {
            result = inputField.filter!.inputField(inputField, shouldChangeTextIn: range, replacementText: string)
        }
        
        if result && self.holdedTextField != nil && self.holdedTextField!.formatter != nil
        {
            result = self.holdedTextField!.formatter!.formatWithNewCharactersIn(range: range, replacementString: string)
        }

        if result && self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textField(_:shouldChangeCharactersIn:replacementString:) != nil
        {
            result = self.holdedTextField!.smdelegate!.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return result
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldShouldClear(_:) != nil
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldClear!(textField)
        }
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var result: Bool = true
        
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && self.holdedTextField!.smdelegate!.textFieldShouldReturn(_:) != nil
        {
            result = self.holdedTextField!.smdelegate!.textFieldShouldReturn!(textField)
        }
        
        if result && self.holdedTextField!.keyboardAvoiding != nil
        {
            self.holdedTextField!.keyboardAvoiding!.responderShouldReturn(textField)
        }
        
        return true
    }
}

