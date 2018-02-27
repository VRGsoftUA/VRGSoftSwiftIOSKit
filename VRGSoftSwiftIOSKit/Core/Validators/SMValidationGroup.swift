//
//  SMValidationGroup.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/23/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation
import UIKit

open class SMValidationGroup
{
    var validators: [SMValidator] = []

    open func add(validator aValidator: SMValidator) -> Void
    {
        validators.append(aValidator)
    }

    open func add(validators aValidators: [SMValidator]) -> Void
    {
        validators.append(contentsOf: aValidators)
    }
    
    open func removeAllValidators() -> Void
    {
        validators.removeAll()
    }
    
    open func validate() -> [SMValidationProtocol]
    {
        var result: [SMValidationProtocol] = []
        
        for validator: SMValidator in validators
        {
            if !validator.validate()
            {
                result.append(validator.validatableObject!)
            }
        }
        
        return result
    }
    
    open func applyShakeForWrongFieldsIfCan() -> Void
    {
        for obj: SMValidationProtocol in self.validate()
        {
            if let view: UIView = obj as? UIView
            {
                view.transform = CGAffineTransform(translationX: 15, y: 0)
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations:
                {
                    view.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
}
