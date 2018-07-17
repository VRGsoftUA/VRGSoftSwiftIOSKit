//
//  SMKeyboardAvoider.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 5/18/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

open class SMKeyboardAvoider: SMKeyboardAvoidingProtocol, SMKeyboardToolbarDelegate
{
    open var priorInset: UIEdgeInsets = UIEdgeInsets()
    open var isKeyboardVisible: Bool = false
    open var _keyboardRect: CGRect = CGRect.zero
    open var originalContentSize: CGSize = CGSize.zero
    open var objectsInKeyboard: [UIResponder] = []
    open var indexPathseObjectsInKeyboard: [IndexPath: [UIResponder]] = [:]
    open var lastReturnKeyType: UIReturnKeyType = UIReturnKeyType.go
    open var selectIndexInputField: Int = 0
    
    open let scrollView: UIScrollView
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    open init(scrollView aScrollView: UIScrollView)
    {
        scrollView = aScrollView
        setup()
    }
    
    open func setup()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(SMKeyboardAvoider.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMKeyboardAvoider.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMKeyboardAvoider.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    open func contentInsetForKeyboard() -> UIEdgeInsets
    {
        var result: UIEdgeInsets = self.scrollView.contentInset
        
        let keyboardRect: CGRect = self.keyboardRect()
        result.bottom = keyboardRect.size.height - ((keyboardRect.origin.y + keyboardRect.size.height) - (self.scrollView.bounds.origin.y + self.scrollView.bounds.size.height))
        
        if result.bottom < 0
        {
            result.bottom = 0
        }
        
        return result
    }
    
    open func keyboardRect() -> CGRect
    {
        var keyboardRect: CGRect = self.scrollView.convert(_keyboardRect, from: nil)
        
        if keyboardRect.origin.y == 0
        {
            let screenBounds = self.scrollView.convert(UIScreen.main.bounds, from: nil)
            
            keyboardRect.origin = CGPoint(x: 0, y: screenBounds.size.height - keyboardRect.size.height)
        }
        
        return keyboardRect
    }
    
    open func idealOffsetFor(view aView: UIView?, withSpace aSpace: CGFloat) -> CGFloat
    {
        var offset: CGFloat = 0
        
        if let view = aView
        {
            if let index = objectsInKeyboard.index(of: view)
            {
                self.selectIndexInputField = index
                
                if let keyboardToolbar = keyboardToolbar
                {
                    keyboardToolbar.selectedInputField(index: self.selectIndexInputField, allCount: objectsInKeyboard.count)
                }
            }
            
            let rect: CGRect = view.convert(view.bounds, to: scrollView)
            
            offset = rect.origin.y
            
            if self.scrollView.contentSize.height - offset < aSpace
            {
                offset -= (floor(aSpace - view.bounds.size.height) - 20)
            } else
            {
                if view.bounds.size.height < aSpace
                {
                    offset -= (floor(aSpace - view.bounds.size.height) - 20)
                }
                if offset + aSpace > scrollView.contentSize.height
                {
                    offset = scrollView.contentSize.height - aSpace
                }
            }
            
            if offset < 0
            {
                offset = 0
            }
        }
        
        return offset
    }
    
    open func findFirstResponderBeneath(view aView: UIView) -> UIResponder?
    {
        var result: UIResponder? = nil
        
        for childView: UIView in aView.subviews
        {
            if childView.responds(to: #selector(getter: UIResponder.isFirstResponder)) && childView.isFirstResponder
            {
                result = childView
                
                break
            }
            
            result = findFirstResponderBeneath(view: childView)
            
            if result != nil
            {
                break
            }
        }
        
        return result
    }
        
    // MARK: - NSNotification
    
    @objc open func keyboardWillShow(_ notification: Notification)
    {
        DispatchQueue.main.async {
            
            for responder in self.objectsInKeyboard
            {
                if responder.isFirstResponder,
                    let responder: UITextInputTraits = responder as? UITextInputTraits
                {
                    if let keyboardAppearance: UIKeyboardAppearance = responder.keyboardAppearance
                    {
                        self.keyboardToolbar?.setKeyboardAppearance(keyboardAppearance)
                    }
                }
            }
        }
        
        guard let kbRect: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            return
        }
        
        if kbRect.size.height > _keyboardRect.size.height || !isKeyboardVisible
        {
            if kbRect.size.height > 0
            {
                self._keyboardRect = kbRect
                self.isKeyboardVisible = true
                
                if let firstResponder = self.findFirstResponderBeneath(view: scrollView)
                {
                    if self.objectsInKeyboard.contains(firstResponder)
                    {
                        self.selectIndexInputField = self.objectsInKeyboard.index(of: firstResponder) ?? 0
                    }
                    
                    self.priorInset = self.scrollView.contentInset
                    
                    self.scrollView.contentInset = self.contentInsetForKeyboard()
                    
                    self.adjustOffset()
                }
            }
        }
    }
    
    @objc open func keyboardWillHide(_ notification: Notification)
    {
        _keyboardRect = CGRect.zero
        isKeyboardVisible = false
        selectIndexInputField = 0
        
        if let cgRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            _keyboardRect = cgRectValue
        }
        
        if let duration: Double = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        {
            UIView.animate(withDuration: duration) {
                self.scrollView.contentInset = self.priorInset
            }
        }
        
        self.adjustOffset()
    }
    
    @objc open func keyboardDidHide(_ notification: Notification)
    {
        if scrollView.contentOffset.y > 0 && scrollView.frame.size.height > scrollView.contentSize.height - 20
        {
            scrollView.contentOffset = CGPoint.zero
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
    
    public func adjustOffset()
    {
        if !isKeyboardVisible
        {
            return
        }
        
        let visibleSpace: CGFloat = scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let idealOffset = CGPoint(x: 0, y: self.idealOffsetFor(view: self.findFirstResponderBeneath(view: scrollView) as? UIView, withSpace: visibleSpace))
        
        scrollView.setContentOffset(idealOffset, animated: true)
    }
    
    public func hideKeyBoard()
    {
        let responder: UIResponder? = self.findFirstResponderBeneath(view: scrollView)
        
        responder?.resignFirstResponder()
    }
    
    public func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder)
    {
        if self.objectsInKeyboard.count > 0
        {
            (self.objectsInKeyboard.last as? UITextField)?.returnKeyType = UIReturnKeyType.next
            (self.objectsInKeyboard.last as? UITextView)?.returnKeyType = UIReturnKeyType.next
            (self.objectsInKeyboard.last as? UISearchBar)?.returnKeyType = UIReturnKeyType.next
        }
        
        (aObjectForKeyboard as? UITextField)?.returnKeyType = lastReturnKeyType
        (aObjectForKeyboard as? UITextView)?.returnKeyType = lastReturnKeyType
        (aObjectForKeyboard as? UISearchBar)?.returnKeyType = lastReturnKeyType

        self.objectsInKeyboard.append(aObjectForKeyboard)
        
        (aObjectForKeyboard as? SMKeyboardAvoiderProtocol)?.keyboardAvoiding = self
    }
    
    public func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder)
    {
        if self.objectsInKeyboard.contains(aObjectForKeyboard), let index = self.objectsInKeyboard.index(of: aObjectForKeyboard)
        {
            objectsInKeyboard.remove(at: index)
            
            if objectsInKeyboard.count > 0
            {
                (objectsInKeyboard.last as? UITextField)?.returnKeyType = lastReturnKeyType
                (objectsInKeyboard.last as? UITextView)?.returnKeyType = lastReturnKeyType
                (objectsInKeyboard.last as? UISearchBar)?.returnKeyType = lastReturnKeyType
            }
        }
        
        
        var deleteIndexPath: IndexPath? = nil
        
        for сortege in self.indexPathseObjectsInKeyboard
        {
            let responders = сortege.value
            
            for obj in responders where obj == aObjectForKeyboard
            {
                deleteIndexPath = сortege.key
                break
            }
        }
        
        if let deleteIndexPath = deleteIndexPath
        {
            self.indexPathseObjectsInKeyboard.removeValue(forKey: deleteIndexPath)
        }
    }
    
    public func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder])
    {
        for obj in aObjectsForKeyboard
        {
            (obj as? UITextField)?.inputAccessoryView = keyboardToolbar
            (obj as? UITextView)?.inputAccessoryView = keyboardToolbar
            (obj as? UISearchBar)?.inputAccessoryView = keyboardToolbar
            
            self.addObjectForKeyboard(obj)
        }
    }
    
    public func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder])
    {
        for obj in aObjectsForKeyboard
        {
            self.removeObjectForKeyboard(obj)
        }
    }
    
    public func removeAllObjectsForKeyboard()
    {
        objectsInKeyboard.removeAll()
        indexPathseObjectsInKeyboard.removeAll()
    }
    
    public func responderShouldReturn(_ aResponder: UIResponder)
    {
        let index: Int = self.objectsInKeyboard.index(of: aResponder) ?? NSNotFound
        
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
    
    open func createToolbar()
    {
        self.keyboardToolbar = SMKeyboardToolbar(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 44.0))
        self.keyboardToolbar?.smdelegate = self
        self.setInputAccessoryView(keyboardToolbar)
    }
    
    open func deleteToolbar()
    {
        keyboardToolbar = nil
        self.setInputAccessoryView(keyboardToolbar)
    }
    
    open func setInputAccessoryView(_ aAccessoryView: UIView?)
    {
        for obj in self.objectsInKeyboard
        {
            (obj as? UITextField)?.inputAccessoryView = aAccessoryView
            (obj as? UITextView)?.inputAccessoryView = aAccessoryView
            (obj as? UISearchBar)?.inputAccessoryView = aAccessoryView
        }
    }
    
    
    // MARK: - SMKeyboardToolbarDelegate
    
    public func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtNextClicked aSender: AnyObject)
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
    
    public func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtBackClicked aSender: AnyObject)
    {
        if selectIndexInputField >= 1
        {
            selectIndexInputField -= 1
            
            let inputField = objectsInKeyboard[selectIndexInputField]
            
            if !inputField.becomeFirstResponder()
            {
                if isKeyboardVisible
                {
                    let visibleSpace: CGFloat = scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                    let idealOffset: CGPoint = CGPoint(x: 0, y: self.idealOffsetFor(view: inputField as? UIView, withSpace: visibleSpace))
                    scrollView.setContentOffset(idealOffset, animated: true)
                }
            }
        } else
        {
            self.hideKeyBoard()
        }
    }
    
    public func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtDoneClicked aSender: AnyObject)
    {
        self.hideKeyBoard()
    }
    
    func sortedResponders(_ aResponders: [UIResponder], byIndexPath aIndexPath: IndexPath)
    {
        objectsInKeyboard.removeAll()
        
        if self.indexPathseObjectsInKeyboard[aIndexPath] != nil
        {
            var temp: IndexPath = aIndexPath
            var tempIndexPathseObjectsInKeyboard: [IndexPath: [UIResponder]] = [:]
            
            for сortege in self.indexPathseObjectsInKeyboard
            {
                if сortege.key == temp
                {
                    if сortege.key == aIndexPath
                    {
                        tempIndexPathseObjectsInKeyboard[aIndexPath] = aResponders
                        temp = IndexPath(row: сortege.key.row + 1, section: сortege.key.section)
                        tempIndexPathseObjectsInKeyboard[сortege.key] = self.indexPathseObjectsInKeyboard[temp]
                    }
                } else
                {
                    tempIndexPathseObjectsInKeyboard[сortege.key] = self.indexPathseObjectsInKeyboard[сortege.key]
                }
            }
            
            self.indexPathseObjectsInKeyboard = tempIndexPathseObjectsInKeyboard
        } else
        {
            self.indexPathseObjectsInKeyboard[aIndexPath] = aResponders
        }
        

        let sordetIndexPath = self.indexPathseObjectsInKeyboard.sorted { (aCortege1, aCortege2) -> Bool in
            return aCortege1.key.section <= aCortege2.key.section && aCortege1.key.row <= aCortege2.key.row
        }
        
        for сortege in sordetIndexPath
        {
            let responders: [UIResponder] = сortege.value
            
            for responder in сortege.value
            {
                (responder as? UITextField)?.returnKeyType = UIReturnKeyType.next
                (responder as? UITextView)?.returnKeyType = UIReturnKeyType.next
                (responder as? UISearchBar)?.returnKeyType = UIReturnKeyType.next
            }
            
            self.objectsInKeyboard.append(contentsOf: responders)
        }
        
        if self.objectsInKeyboard.count > 0
        {
            (self.objectsInKeyboard.last as? UITextField)?.returnKeyType = lastReturnKeyType
            (self.objectsInKeyboard.last as? UITextView)?.returnKeyType = lastReturnKeyType
            (self.objectsInKeyboard.last as? UISearchBar)?.returnKeyType = lastReturnKeyType
        }
    }
}
