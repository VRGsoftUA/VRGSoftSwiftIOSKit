//
//  SMKeyboardAvoidingScrollView.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/10/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMKeyboardAvoidingScrollView: UIScrollView, SMKeyboardAvoidingProtocol
{
    var _keyboardAvoider: SMKeyboardAvoider?
    var keyboardAvoider: SMKeyboardAvoider
    {
        if let keyboardAvoider: SMKeyboardAvoider = _keyboardAvoider
        {
            return keyboardAvoider
        } else
        {
            let result: SMKeyboardAvoider = SMKeyboardAvoider(scrollView: self)
            _keyboardAvoider = result
            return result
        }
    }

    public override init(frame: CGRect)
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
        if contentSize.equalTo(CGSize.zero)
        {
            self.contentSize = self.bounds.size
        }

        keyboardAvoider.originalContentSize = self.contentSize
    }
    
    override open var frame: CGRect
    {
        didSet
        {
            var newContentSize: CGSize = keyboardAvoider.originalContentSize
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)
            
            super.contentSize = newContentSize
            
            if keyboardAvoider.isKeyboardVisible
            {
                self.contentInset = keyboardAvoider.contentInsetForKeyboard()
            }
        }
    }
    
    override open var contentSize: CGSize
    {
        set
        {
            keyboardAvoider.originalContentSize = newValue
            
            var newContentSize: CGSize = keyboardAvoider.originalContentSize
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)
            
            super.contentSize = newContentSize
            
            if keyboardAvoider.isKeyboardVisible
            {
                self.contentInset = keyboardAvoider.contentInsetForKeyboard()
            }
        }
        
        get { return super.contentSize }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
     
        self.hideKeyBoard()
    }
    
    
    // MARK: - SMKeyboardAvoidingProtocol

    public var keyboardToolbar: SMKeyboardToolbar?

    public var isShowsKeyboardToolbar: Bool
    {
        set
        {
            keyboardAvoider.isShowsKeyboardToolbar = newValue
        }
        
        get
        {
            return keyboardAvoider.isShowsKeyboardToolbar
        }
    }

    public func adjustOffset()
    {
        keyboardAvoider.adjustOffset()
    }

    public func hideKeyBoard()
    {
        keyboardAvoider.hideKeyBoard()
    }
    
    public func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder)
    {
        keyboardAvoider.addObjectForKeyboard(aObjectForKeyboard)
    }
    
    public func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder)
    {
        keyboardAvoider.removeObjectForKeyboard(aObjectForKeyboard)
    }
    
    public func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder])
    {
        keyboardAvoider.addObjectsForKeyboard(aObjectsForKeyboard)
    }
    
    public func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder])
    {
        keyboardAvoider.removeObjectsForKeyboard(aObjectsForKeyboard)
    }
    
    public func removeAllObjectsForKeyboard()
    {
        keyboardAvoider.removeAllObjectsForKeyboard()
    }
    
    public func responderShouldReturn(_ aResponder: UIResponder)
    {
        keyboardAvoider.responderShouldReturn(aResponder)
    }
}
