//
//  SMTextView.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

open class SMTextView: UITextView, SMKeyboardAvoiderProtocol, SMValidationProtocol, SMFilterProtocol
{
    var smdelegate: UITextViewDelegate?
    
    var delegateHolder: SMTextViewDelegateHolder?
    
    override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    open func setup() -> Void
    {
        delegateHolder = SMTextViewDelegateHolder(textView: self)
        self.delegate = delegateHolder
    }

    
    // MARK: - PlaceHolder
    
    var _placeholderTextView: UITextView?
    var placeholderTextView: UITextView!
    {
        get
        {
            if _placeholderTextView == nil
            {
                _placeholderTextView = UITextView(frame: self.bounds)
                
                _placeholderTextView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                _placeholderTextView!.backgroundColor = UIColor.clear
                _placeholderTextView!.font = self.font
                _placeholderTextView!.textColor = UIColor.gray
                _placeholderTextView!.isEditable = false
                _placeholderTextView!.isUserInteractionEnabled = false
                _placeholderTextView!.isHidden = self.text.count > 0
                _placeholderTextView!.textContainerInset = self.textContainerInset
                self.addSubview(_placeholderTextView!)
            }
            
            return _placeholderTextView
        }
    }

    var placeholder: String!
    {
        set
        {
            self.placeholderTextView.text = newValue
            self.placeholderTextView!.isHidden = self.text.count > 0
        }
        
        get { return self.placeholderTextView.text }
    }
    
    var attributedPlaceholder: NSAttributedString!
    {
        set
        {
            self.placeholderTextView.attributedText = newValue
            self.placeholderTextView!.isHidden = self.text.count > 0
        }
        
        get { return self.attributedText }
    }
    
    var placeholderColor: UIColor?
    {
        set
        {
            self.placeholderTextView.textColor = newValue
        }
        
        get { return self.placeholderTextView.textColor }
    }

    override var textContainerInset: UIEdgeInsets
    {
        set
        {
            super.textContainerInset = newValue
            self.placeholderTextView.textContainerInset = newValue
        }
        
        get { return super.textContainerInset }
    }

    override var textAlignment: NSTextAlignment
    {
        set
        {
            super.textAlignment = newValue
            self.placeholderTextView.textAlignment = newValue
        }
        
        get { return super.textAlignment }
    }

    var isPlaceHolderHidden: Bool
    {
        set
        {
            if _placeholderTextView != nil
            {
                self.placeholderTextView.isHidden = newValue
            }
        }
        
        get { return placeholderTextView.isHidden }
    }
    
    override var text: String!
    {
        set
        {
            super.text = newValue
            self.placeholderTextView!.isHidden = self.text.count > 0
        }
        
        get { return super.text }
    }
    
    override var font: UIFont?
    {
        set
        {
            super.font = newValue
            self.placeholderTextView.font = newValue
        }
        
        get { return super.font }
    }

    
    // MARK: - SMKeyboardAvoiderProtocol
    
    public weak var keyboardAvoiding: SMKeyboardAvoidingProtocol?
    
    
    // MARK: - SMFilterProtocol
    
    var filteredText: String? {get {return self.text}}
    
    var filter: SMFilter?

    
    // MARK: - SMValidationProtocol
    var validatableText: String?
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
    
    var validator: SMValidator?
    {
        didSet
        {
            if validator != nil
            {
                validator!.validatableObject = self
            }
        }
    }
    
    func validate() -> Bool
    {
        return ((validator) != nil) ? validator!.validate() : true
    }
}

open class SMTextViewDelegateHolder: NSObject, UITextViewDelegate
{
    weak var holdedTextView: SMTextView?
    
    required init(textView aTextView: SMTextView)
    {
        super.init()
        
        holdedTextView = aTextView
    }
    
    
    // MARK: - UITextViewDelegate
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textViewShouldBeginEditing(_:) != nil
        {
            return self.holdedTextView!.smdelegate!.textViewShouldBeginEditing!(_:textView)
        }
        
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textViewShouldEndEditing(_:) != nil
        {
            return self.holdedTextView!.smdelegate!.textViewShouldEndEditing!(_:textView)
        }
        
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView)
    {
        if self.holdedTextView != nil && self.holdedTextView!.keyboardAvoiding != nil
        {
            self.holdedTextView!.keyboardAvoiding!.adjustOffset()
        }

        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textViewDidBeginEditing(_:) != nil
        {
            self.holdedTextView!.smdelegate!.textViewDidBeginEditing!(_:textView)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textViewDidEndEditing(_:) != nil
        {
            self.holdedTextView!.smdelegate!.textViewDidEndEditing!(_:textView)
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        var result = true
        
        let inputField = textView as! SMTextView
        
        if inputField.filter != nil
        {
            result = inputField.filter!.inputField(inputField, shouldChangeTextIn: range, replacementText: text)
        }
        
        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textView(_:shouldChangeTextIn:replacementText:) != nil
        {
            return self.holdedTextView!.smdelegate!.textView!(_: textView,shouldChangeTextIn: range, replacementText:text)
        }
        
        if result
        {
            let newText: String = (textView.text! as NSString).replacingCharacters(in: range, with: text)

            (textView as! SMTextView).isPlaceHolderHidden = newText.count > 0
        }

        return result
    }
    
    public func textViewDidChange(_ textView: UITextView)
    {
        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textViewDidChange(_:) != nil
        {
            self.holdedTextView!.smdelegate!.textViewDidChange!(_:textView)
        }
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView)
    {
        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.textViewDidChangeSelection(_:) != nil
        {
            self.holdedTextView!.smdelegate!.textViewDidChangeSelection!(_:textView)
        }
    }
    
//    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
//    {
//        if self.holdedTextView != nil && self.holdedTextView!.smdelegate != nil && self.holdedTextView!.smdelegate!.responds(to: #selector(UITextViewDelegate.textView(_:shouldInteractWith:in:interaction:)))
//        {
//            return self.holdedTextView!.smdelegate!.textView!(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction)
//        }
//        
//        return true
//    }
    
//    @available(iOS 10.0, *)
//    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
//    {
//        
//    }
    
//    optional public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
//    {
//        
//    }
//    
//    optional public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool
//    {
//        
//    }
}

