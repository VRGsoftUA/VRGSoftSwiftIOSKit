//
//  SMKeyboardToolbar.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 8/10/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

public protocol SMKeyboardToolbarDelegate : class
{
    func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtNextClicked aSender: AnyObject) -> Void
    func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtBackClicked aSender: AnyObject) -> Void
    func keyboardToolbar(_ aKeyboardToolbar: SMKeyboardToolbar, didBtDoneClicked aSender: AnyObject) -> Void
}

open class SMKeyboardToolbar: SMToolbar
{
    open weak var smdelegate: SMKeyboardToolbarDelegate?
    
    open let bbiDone: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SMKeyboardToolbar.didBtDoneClicked(_:)))
    
    open let bbiBack: UIBarButtonItem = UIBarButtonItem()
    open let bbiNext: UIBarButtonItem = UIBarButtonItem()
    
    open override func setup() -> Void
    {
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.barStyle = UIBarStyle.default
        self.isTranslucent = true

        self.createButtons()
        
        let vLine: UIView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5))
        vLine.backgroundColor = UIColor.black
        vLine.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        self.addSubview(vLine)
    }
    
    func createButtons() -> Void
    {
        let mainBundle: Bundle = Bundle(for: type(of: self))
        
        let resourcesBundle: Bundle = Bundle(path: mainBundle.path(forResource: "VRGSoftSwiftIOSKit", ofType: "bundle")!)!
        
        let btBack: UIButton = UIButton(type: UIButtonType.system)
        let imageLeft: UIImage = UIImage(named: "SMKeyboardAvoideBarArrowLeft", in: resourcesBundle, compatibleWith: nil)!
        btBack.setImage(imageLeft, for: UIControlState.normal)
        btBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btBack.addTarget(self, action: #selector(SMKeyboardToolbar.didBtBackClicked(_:)), for: UIControlEvents.touchUpInside)
        bbiBack.customView = btBack
        
        
        let btNext: UIButton = UIButton(type: UIButtonType.system)
        let imageRight: UIImage = UIImage(named: "SMKeyboardAvoideBarArrowRight", in: resourcesBundle, compatibleWith: nil)!
        btNext.setImage(imageRight, for: UIControlState.normal)
        btNext.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btNext.addTarget(self, action: #selector(SMKeyboardToolbar.didBtNextClicked(_:)), for: UIControlEvents.touchUpInside)
        bbiNext.customView = btNext
        
        let bbiFlex: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let bbiFixed: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        bbiFixed.width = 10
        
        self.items = [bbiBack,bbiNext, bbiFlex, bbiDone,bbiFixed]
    }
    
    func setKeyboardAppearance(_ aKeyboardAppearance: UIKeyboardAppearance)
    {
        switch aKeyboardAppearance
        {
        case .default:
            self.barTintColor = UIColor(red: 210.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            self.tintColor = UIColor.black
        case .light:
            self.barTintColor = UIColor(red: 210.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            self.tintColor = UIColor.black

        case .dark:
            self.barTintColor = UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 0.97)
            self.tintColor = UIColor.white
        }
    }
    
    func selectedInputField(index aIndex: Int, allCount aAllCountInputFields: Int) -> Void
    {
        if aIndex > 0
        {
            bbiBack.isEnabled = true
        } else
        {
            bbiBack.isEnabled = false
        }
        
        if aIndex < aAllCountInputFields - 1
        {
            bbiNext.isEnabled = true
        } else
        {
            bbiNext.isEnabled = false
        }
    }
    
    
    // MARK: - Actions

    @objc func didBtBackClicked(_ sender: AnyObject) -> Void
    {
        if smdelegate != nil
        {
            smdelegate!.keyboardToolbar(self, didBtBackClicked: sender)
        }
    }

    @objc func didBtNextClicked(_ sender: AnyObject) -> Void
    {
        if smdelegate != nil
        {
            smdelegate!.keyboardToolbar(self, didBtNextClicked: sender)
        }
    }

    @objc func didBtDoneClicked(_ sender: AnyObject) -> Void
    {
        if smdelegate != nil
        {
            smdelegate!.keyboardToolbar(self, didBtDoneClicked: sender)
        }
    }
}
