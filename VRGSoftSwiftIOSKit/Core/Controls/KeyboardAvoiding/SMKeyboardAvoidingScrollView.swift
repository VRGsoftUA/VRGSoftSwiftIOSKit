//
//  SMKeyboardAvoidingScrollView.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/10/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMKeyboardAvoidingScrollView: UIScrollView, SMKeyboardAvoidingProtocol, SMKeyboardToolbarDelegate
{
    var priorInset: UIEdgeInsets = UIEdgeInsets()
    open var isKeyboardVisible: Bool = false
    var _keyboardRect: CGRect = CGRect.zero
    var originalContentSize: CGSize?
    var objectsInKeyboard: [UIResponder] = []
    
    var selectIndexInputField: Int = 0
    
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
    
    func idealOffsetFor(view aView: UIView?, withSpace aSpace: CGFloat) -> CGFloat
    {
        var offset: CGFloat = 0
        
        if aView != nil
        {
            if aView is UITextInputTraits
            {
                selectIndexInputField = self.objectsInKeyboard.index(of:aView!)!
                
                if self.keyboardToolbar != nil && selectIndexInputField != NSNotFound
                {
                    self.keyboardToolbar!.selectedInputField(index: selectIndexInputField, allCount: objectsInKeyboard.count)
                }
            }
            
            let rect: CGRect = aView!.convert(aView!.bounds, to: self)
            
            offset = rect.origin.y
            
            if self.contentSize.height - offset < aSpace
            {
                offset -= (floor(aSpace - aView!.bounds.size.height) - 20)
            }
            else
            {
                if aView!.bounds.size.height < aSpace
                {
                    offset -= (floor(aSpace-aView!.bounds.size.height)-20);
                }
                if offset + aSpace > self.contentSize.height
                {
                    offset = self.contentSize.height - aSpace
                }
            }
            
            if offset < 0
            {
                offset = 0
            }

        }

        return offset;
    }
    
    func findFirstResponderBeneath(view aView: UIView) -> UIResponder?
    {
        var result: UIResponder? = nil
        
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

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
     
        self.hideKeyBoard()
    }
    
    // MARK: - NSNotification
    
    func keyboardWillShow(_ notification: Notification) -> Void
    {
        DispatchQueue.main.async {
            
            for responder in self.objectsInKeyboard
            {
                if self.keyboardToolbar != nil && responder.isFirstResponder && responder is UITextInputTraits
                {
                    self.keyboardToolbar!.setKeyboardAppearance((responder as! UITextInputTraits).keyboardAppearance!)
                }
            }
        }
        
        let kbRect: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        if kbRect.size.height > _keyboardRect.size.height || !isKeyboardVisible
        {
            if kbRect.size.height > 0
            {
                _keyboardRect = kbRect
                isKeyboardVisible = true
                
                if let firstResponder = self.findFirstResponderBeneath(view: self)
                {
                    selectIndexInputField = objectsInKeyboard.index(of: firstResponder)!
                    
                    priorInset = self.contentInset
                    
                    self.contentInset = self.contentInsetForKeyboard()
                    
                    self.adjustOffset()
                }
            }
        }
    }

    func keyboardWillHide(_ notification: Notification) -> Void
    {
        _keyboardRect = CGRect.zero;
        isKeyboardVisible = false;
        selectIndexInputField = 0;
        
        _keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration: Double = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: duration) {
            self.contentInset = self.priorInset
        }

        self.adjustOffset()
    }

    func keyboardDidHide(_ notification: Notification) -> Void
    {
        if self.contentOffset.y > 0 && self.frame.size.height > self.contentSize.height - 20
        {
            self.contentOffset = CGPoint.zero
        }
    }
    
    
    // MARK: - SMKeyboardAvoidingProtocol

    public var keyboardToolbar: SMKeyboardToolbar?

    public var isShowsKeyboardToolbar: Bool
    {
        set
        {
            if newValue
            {
                self.createToolbar()
            } else
            {
                self.deleteToolbar()
            }
        }
        
        get
        {
            return self.keyboardToolbar != nil
        }
    }

    public func adjustOffset() -> Void
    {
        if !isKeyboardVisible
        {
            return
        }
        
        let visibleSpace: CGFloat = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        let idealOffset = CGPoint(x: 0, y: self.idealOffsetFor(view: self.findFirstResponderBeneath(view: self) as? UIView, withSpace: visibleSpace))
        
        self.setContentOffset(idealOffset, animated: true)
    }

    public func hideKeyBoard() -> Void
    {
        let responder: UIResponder? = self.findFirstResponderBeneath(view: self)
        
        if responder != nil
        {
            responder!.resignFirstResponder()
        }
    }
    
    public func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder) -> Void
    {
        if self.objectsInKeyboard.count > 0
        {
            if self.objectsInKeyboard.last is UITextField
            {
                (self.objectsInKeyboard.last as! UITextField).returnKeyType = UIReturnKeyType.next
            } else if self.objectsInKeyboard.last is UITextView
            {
                (self.objectsInKeyboard.last as! UITextView).returnKeyType = UIReturnKeyType.next
            } else if self.objectsInKeyboard.last is UISearchBar
            {
                (self.objectsInKeyboard.last as! UISearchBar).returnKeyType = UIReturnKeyType.next
            }
        }
        
        if aObjectForKeyboard is UITextField
        {
            (aObjectForKeyboard as! UITextField).returnKeyType = UIReturnKeyType.done
        } else if aObjectForKeyboard is UITextView
        {
            (aObjectForKeyboard as! UITextView).returnKeyType = UIReturnKeyType.done
        } else if aObjectForKeyboard is UISearchBar
        {
            (aObjectForKeyboard as! UISearchBar).returnKeyType = UIReturnKeyType.done
        }

        self.objectsInKeyboard.append(aObjectForKeyboard)

        if aObjectForKeyboard is SMKeyboardAvoiderProtocol
        {
            (aObjectForKeyboard as! SMKeyboardAvoiderProtocol).keyboardAvoiding = self
        }
    }
    
    public func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder) -> Void
    {
        
        let index = self.objectsInKeyboard.index(of: aObjectForKeyboard)

        if index != NSNotFound
        {
            objectsInKeyboard.remove(at: index!)
        }
    }
    
    public func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) -> Void
    {        
        for obj in aObjectsForKeyboard
        {
            if obj is UITextField
            {
                (obj as! UITextField).inputAccessoryView = self.keyboardToolbar
            } else if obj is UITextView
            {
                (obj as! UITextView).inputAccessoryView = self.keyboardToolbar
            } else if obj is UISearchBar
            {
                (obj as! UISearchBar).inputAccessoryView = self.keyboardToolbar
            }
            
            self.addObjectForKeyboard(obj)
        }
    }
    
    public func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) -> Void
    {
        for obj in aObjectsForKeyboard
        {
            self.removeObjectForKeyboard(obj)
        }
    }
    
    public func removeAllObjectsForKeyboard() -> Void
    {
        objectsInKeyboard.removeAll()
    }
    
    public func responderShouldReturn(_ aResponder: UIResponder) -> Void
    {
        let index = self.objectsInKeyboard.index(of: aResponder)!

        assert(index != NSNotFound, String.init(format: "SMKeyboardAvoidingScrollView: _objectsInKeyboard is empty in %@", NSStringFromClass(type(of: self))))

        if index < self.objectsInKeyboard.count - 1
        {
            selectIndexInputField = index + 1
            objectsInKeyboard[selectIndexInputField].becomeFirstResponder()
        } else
        {
            selectIndexInputField = 0
            aResponder.resignFirstResponder()
        }
    }
    
    func createToolbar() -> Void
    {
        self.keyboardToolbar = SMKeyboardToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44.0))
        self.keyboardToolbar!.smdelegate = self
        self.setInputAccessoryView(keyboardToolbar!)
    }

    func deleteToolbar() -> Void
    {
        keyboardToolbar = nil
        self.setInputAccessoryView(keyboardToolbar!)
    }
    
    func setInputAccessoryView(_ aAccessoryView: UIView) -> Void
    {
        for obj in self.objectsInKeyboard
        {
            if obj is UITextField
            {
                (obj as! UITextField).inputAccessoryView = self.keyboardToolbar
            } else if obj is UITextView
            {
                (obj as! UITextView).inputAccessoryView = self.keyboardToolbar
            } else if obj is UISearchBar
            {
                (obj as! UISearchBar).inputAccessoryView = self.keyboardToolbar
            }
        }
    }
    

    // MARK: - SMKeyboardToolbarDelegate
    
    public func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtNextClicked aSender: AnyObject) -> Void
    {
        if selectIndexInputField < objectsInKeyboard.count - 1
        {
            selectIndexInputField += 1
            
            let inputField = objectsInKeyboard[selectIndexInputField]
            inputField.becomeFirstResponder()
        } else
        {
            self.hideKeyBoard()
        }
    }
    
    public func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtBackClicked aSender: AnyObject) -> Void
    {
        if selectIndexInputField >= 1
        {
            selectIndexInputField -= 1
            
            let inputField = objectsInKeyboard[selectIndexInputField]
            
            if !inputField.becomeFirstResponder()
            {
                if isKeyboardVisible
                {
                    let visibleSpace: CGFloat = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
                    let idealOffset: CGPoint = CGPoint(x: 0, y: self.idealOffsetFor(view: inputField as? UIView, withSpace: visibleSpace))
                    self.setContentOffset(idealOffset, animated: true)
                }
            } else
            {
                self.hideKeyBoard()
            }
        }
    }
    
    public func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtDoneClicked aSender: AnyObject) -> Void
    {
        self.hideKeyBoard()
    }
}
