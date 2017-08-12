//
//  ViewController.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/4/17.
//  Copyright © 2017 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var scrollView: SMKeyboardAvoidingScrollView!

    @IBOutlet weak var tvTest: SMTextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        for i in 10...15
        {
            let tf: SMTextField = self.view.viewWithTag(i) as! SMTextField
            
            self.scrollView.addObjectForKeyboard(tf)
        }
        
        self.scrollView.addObjectForKeyboard(self.tvTest)
        self.scrollView.isShowsKeyboardToolbar = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

