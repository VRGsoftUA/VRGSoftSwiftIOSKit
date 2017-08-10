//
//  SMKeyboardAvoiding.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/10/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

public protocol SMKeyboardAvoidingProtocol: NSObjectProtocol
{
    var keyboardToolbar: SMKeyboardToolbar {get}
    var isShowsKeyboardToolbar: Bool {get set}

    func adjustOffset() -> Void
    func hideKeyBoard() -> Void
    
    func addObjectForKeyboard(_ aObjectForKeyboard: SMKeyboardAvoiderProtocol) -> Void
    func removeObjectForKeyboard(_ aObjectForKeyboard: SMKeyboardAvoiderProtocol) -> Void

    func addObjectsForKeyboard(_ aObjectsForKeyboard: [SMKeyboardAvoiderProtocol]) -> Void
    func removeObjectsForKeyboard(_ aObjectsForKeyboard: [SMKeyboardAvoiderProtocol]) -> Void

    func removeAllObjectsForKeyboard() -> Void
    
    func responderShouldReturn(_ aResponder: UIResponder) -> Void
}

public protocol SMKeyboardAvoiderProtocol: NSObjectProtocol
{
    var keyboardAvoiding: SMKeyboardAvoidingProtocol {get set}
}
