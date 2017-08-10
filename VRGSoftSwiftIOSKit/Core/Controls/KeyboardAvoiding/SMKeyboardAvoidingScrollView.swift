//
//  SMKeyboardAvoidingScrollView.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/10/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMKeyboardAvoidingScrollView: UIScrollView
{
    var priorInset: UIEdgeInsets = UIEdgeInsets()
    var isKeyboardVisible: Bool = false
    var _keyboardRect: CGRect = CGRect.zero
    var originalContentSize: CGSize?
    var objectsInKeyboard: [SMKeyboardAvoiderProtocol] = []
    
    var selectIndexInputField: UInt = 0
    var keyboardToolbar: SMKeyboardToolbar?
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override init(frame: CGRect)
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
        originalContentSize = self.contentSize
        
        if self.contentSize.equalTo(CGSize.zero)
        {
            self.contentSize = self.bounds.size
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMKeyboardAvoidingScrollView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(SMKeyboardAvoidingScrollView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(SMKeyboardAvoidingScrollView.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    open override var frame: CGRect
    {
        didSet
        {
            if originalContentSize != nil
            {
                var newContentSize: CGSize = originalContentSize!
                newContentSize.width = max(newContentSize.width, self.frame.size.width)
                newContentSize.height = max(newContentSize.height, self.frame.size.height)
                
                super.contentSize = newContentSize
                
                if isKeyboardVisible
                {
                    self.contentInset = self.contentInsetForKeyboard()
                }
            }
        }
    }
    
    open override var contentSize: CGSize
    {
        set
        {
            originalContentSize = newValue
            
            var newContentSize: CGSize = originalContentSize!
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)

            super.contentSize = newContentSize
            
            if isKeyboardVisible
            {
                self.contentInset = self.contentInsetForKeyboard()
            }
        }
        
        get { return super.contentSize }
    }
    
    func contentInsetForKeyboard() -> UIEdgeInsets
    {
        var result: UIEdgeInsets = self.contentInset
        
        let keyboardRect: CGRect = self.keyboardRect()
        result.bottom = keyboardRect.size.height - ((keyboardRect.origin.y + keyboardRect.size.height) - (self.bounds.origin.y+self.bounds.size.height))
        
        if result.bottom < 0
        {
            result.bottom = 0
        }
        
        return result
    }
    
    func keyboardRect() -> CGRect
    {
        var keyboardRect: CGRect = self.convert(_keyboardRect, from: nil)
        
        if keyboardRect.origin.y == 0
        {
            let screenBounds = self.convert(UIScreen.main.bounds, from: nil)
                
            keyboardRect.origin = CGPoint(x: 0, y: screenBounds.size.height - keyboardRect.size.height)
        }
        
        return keyboardRect
    }
    
    func adjustOffset() -> Void
    {
        if !isKeyboardVisible
        {
            return
        }
        
        let visibleSpace: CGFloat = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        let idealOffset = CGPoint(x: 0, y: self.idealOffset(forView: self.findFirstResponderBeneath(view: self), withSpace: visibleSpace))
        
        self.setContentOffset(idealOffset, animated: true)
    }
    
    func idealOffset(forView aView: UIView?, withSpace aSpace: CGFloat) -> CGFloat
    {
        return 0
    }
    
    func findFirstResponderBeneath(view aView: UIView) -> UIView?
    {
        var result: UIView? = nil
        
        for childView: UIView in aView.subviews
        {
            if childView.responds(to: #selector(getter: UIResponder.isFirstResponder))
            {
                result = childView
                
                break
            }
            
            result = self.findFirstResponderBeneath(view: childView)
            
            if result != nil
            {
                break
            }
        }
        
        return result
    }

    
    // MARK: - NSNotification
    
    func keyboardWillShow(_: Notification) -> Void
    {
        
    }

    func keyboardWillHide(_: Notification) -> Void
    {
        
    }

    func keyboardDidHide(_: Notification) -> Void
    {
        
    }
}
