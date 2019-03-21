//
//  SMKeyboardAvoidingTableView.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/13/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMKeyboardAvoidingTableView: UITableView, SMKeyboardAvoidingProtocol {
    
    public var keyboardToolbar: SMKeyboardToolbar? {
        set {
            keyboardAvoider.keyboardToolbar = newValue
        }
        
        get {
            return keyboardAvoider.keyboardToolbar
        }
    }
    
    var _keyboardAvoider: SMKeyboardAvoider?
    var keyboardAvoider: SMKeyboardAvoider {
        
        if let keyboardAvoider: SMKeyboardAvoider = _keyboardAvoider {
            return keyboardAvoider
        } else {
            let result: SMKeyboardAvoider = SMKeyboardAvoider(scrollView: self)
            _keyboardAvoider = result
            return result
        }
    }

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
        self.setup()
    }
    
    open func setup() {
        
        if self.contentSize.equalTo(CGSize.zero) {
            self.contentSize = self.bounds.size
        }
        
        keyboardAvoider.originalContentSize = self.contentSize
    }
    
    override open var frame: CGRect {
        didSet {
            var newContentSize: CGSize = keyboardAvoider.originalContentSize
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)
            
            super.contentSize = newContentSize
            
            if keyboardAvoider.isKeyboardVisible {
                self.contentInset = keyboardAvoider.contentInsetForKeyboard()
            }
        }
    }
    
    override open var contentSize: CGSize {
        set {
            keyboardAvoider.originalContentSize = newValue
            
            var newContentSize: CGSize = keyboardAvoider.originalContentSize
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)
            
            super.contentSize = newContentSize
            
            if keyboardAvoider.isKeyboardVisible {
                self.contentInset = keyboardAvoider.contentInsetForKeyboard()
            }
        }
        
        get { return super.contentSize }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.hideKeyBoard()
    }
    
    public var isShowsKeyboardToolbar: Bool {
        set {
            keyboardAvoider.isShowsKeyboardToolbar = newValue
        }
        
        get {
            return keyboardAvoider.isShowsKeyboardToolbar
        }
    }
    
    public func adjustOffset() {
        keyboardAvoider.adjustOffset()
    }
    
    public func hideKeyBoard() {
        keyboardAvoider.hideKeyBoard()
    }
    
    public func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder) {
        keyboardAvoider.addObjectForKeyboard(aObjectForKeyboard)
    }
    
    public func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder) {
        keyboardAvoider.removeObjectForKeyboard(aObjectForKeyboard)
    }
    
    public func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) {
        keyboardAvoider.addObjectsForKeyboard(aObjectsForKeyboard)
    }
    
    public func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) {
        keyboardAvoider.removeObjectsForKeyboard(aObjectsForKeyboard)
    }
    
    public func removeAllObjectsForKeyboard() {
        keyboardAvoider.removeAllObjectsForKeyboard()
    }
    
    public func responderShouldReturn(_ aResponder: UIResponder) {
        keyboardAvoider.responderShouldReturn(aResponder)
    }

    func sortedResponders(_ aResponders: [UIResponder], byIndexPath aIndexPath: IndexPath) {
        keyboardAvoider.sortedResponders(aResponders, byIndexPath: aIndexPath)
    }
}
