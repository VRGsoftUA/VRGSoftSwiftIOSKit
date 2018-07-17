//
//  SMKeyboardAvoidingCollectionView.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 5/18/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

class SMKeyboardAvoidingCollectionView: UICollectionView, SMKeyboardAvoidingProtocol
{
    public var keyboardToolbar: SMKeyboardToolbar?
    
    var _keyboardAvoider: SMKeyboardAvoider?
    var keyboardAvoider: SMKeyboardAvoider
    {
        if let keyboardAvoider = _keyboardAvoider
        {
            return keyboardAvoider
        } else
        {
            let result: SMKeyboardAvoider = SMKeyboardAvoider(scrollView: self)
            _keyboardAvoider = result
            return result
        }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
    {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    open func setup()
    {
        if self.contentSize.equalTo(CGSize.zero)
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
    
    func sortedResponders(_ aResponders: [UIResponder], byIndexPath aIndexPath: IndexPath)
    {
        keyboardAvoider.sortedResponders(aResponders, byIndexPath: aIndexPath)
    }
}
