//
//  SMKeyboardAvoiding.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/10/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

public protocol SMKeyboardAvoidingProtocol : class
{
    var keyboardToolbar: SMKeyboardToolbar? {get set}
    var isShowsKeyboardToolbar: Bool {get set}

    func adjustOffset() -> Void
    func hideKeyBoard() -> Void
    
    func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder) -> Void
    func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder) -> Void

    func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) -> Void
    func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) -> Void

    func removeAllObjectsForKeyboard() -> Void
    
    func responderShouldReturn(_ aResponder: UIResponder) -> Void
}

public protocol SMKeyboardAvoiderProtocol : class
{
    weak var keyboardAvoiding: SMKeyboardAvoidingProtocol? {get set}
}
