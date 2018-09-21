//
//  SMValidationGroup.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 12/23/16.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation
import UIKit

public protocol SMValidationGroupProtocol
{
    func applyValideState(group aGroup: SMValidationGroup)
    func applyInvalideState(group aGroup: SMValidationGroup)
}

open class SMValidationGroup
{
    var validators: [SMValidator] = []

    public init()
    {
        
    }
    
    open func add(validator aValidator: SMValidator)
    {
        validators.append(aValidator)
    }

    open func add(validators aValidators: [SMValidator])
    {
        validators.append(contentsOf: aValidators)
    }
    
    open func removeAllValidators()
    {
        validators.removeAll()
    }
    
    open func validate() -> [SMValidationProtocol]
    {
        var result: [SMValidationProtocol] = []
        
        for validator: SMValidator in validators
        {
            if !validator.validate(),
                let validatableObject: SMValidationProtocol = validator.validatableObject
            {
                result.append(validatableObject)
            }
        }
        
        return result
    }
    
    open func applyShakeForWrongFieldsIfCan()
    {
        for obj: SMValidationProtocol in self.validate()
        {
            if let view: UIView = obj as? UIView
            {
                view.transform = CGAffineTransform(translationX: 15, y: 0)
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations:
                {
                    view.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
    
    open func refreshStatesInFields()
    {
        for v: SMValidator in validators
        {
            if let field: SMValidationGroupProtocol = v.validatableObject as? SMValidationGroupProtocol
            {
                if v.validate()
                {
                    field.applyValideState(group: self)
                } else
                {
                    field.applyInvalideState(group: self)
                }
            }
        }
    }
}
