//
//  ViewController.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    @IBOutlet weak var scrollView: SMKeyboardAvoidingScrollView!

    @IBOutlet weak var tvTest: SMTextView!
    
    @IBOutlet weak var vTitle: UIView!
    
    var picker: SMPopupSimplePicker?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        tvTest.smdelegate = self
        
        tvTest.text = nil
        tvTest.placeholder = "test test"
        for i: Int in 10...13
        {
            if let tf: SMTextField = self.view.viewWithTag(i) as? SMTextField
            {
                tf.smdelegate = self
                self.scrollView.addObjectForKeyboard(tf)
            }
        }
        
        self.scrollView.addObjectForKeyboard(self.tvTest)
        self.scrollView.isShowsKeyboardToolbar = true
        
    }
    
    @IBAction func didShowPopoverClicked(sender: UIBarButtonItem)
    {
        
        
    }

    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        //picker = SMPopupDatePicker()
        
        picker = SMPopupSimplePicker()
        
        //dataSource SMTitledID
        let tID = SMTitledID(ID: 3 as NSObject, title: "fourth")
        picker?.dataSource = [SMTitledID(ID: 0 as NSObject, title: "first"),SMTitledID(ID: 1 as NSObject, title: "second"),SMTitledID(ID: 2 as NSObject, title: "therd"),tID,SMTitledID(ID: 4 as NSObject, title: "fifth")]
        picker?.selectedItem = tID
        
        //dataSource String
//        picker?.dataSource = ["one" as AnyObject, "two" as AnyObject, "three" as AnyObject, "four" as AnyObject]
//        picker?.selectedItem = "two" as AnyObject
        
        picker?.toolbar = self.createToolbar()
        picker?.prepareToShow()
 
        if SMHelper.isIPad
        {
            picker?.showFrom(rect: textField.frame, inView: vTitle, permittedArrowDirections: .any)
        } else
        {
            picker?.show(animated: true, inView: vTitle)
        }
        
        return false
    }*/
    
    func createToolbar() -> SMToolbar
    {
        let toolbar: SMToolbar = SMToolbar()
        
        let bbi: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.hide))
        toolbar.items = [bbi]
        
        return toolbar
    }
    
    @objc func hide()
    {
        picker?.hide(animated: true)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        return true
    }
    
}
