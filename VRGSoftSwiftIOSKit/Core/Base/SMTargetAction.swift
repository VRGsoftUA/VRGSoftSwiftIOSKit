//
//  SMTargetAction.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import Foundation

open class SMBlockAction <SenderType>
{
    typealias SMBlockActionBlock = (_ sender: SenderType) -> Void
   
    var block: SMBlockActionBlock
    
    init(block aBlock: @escaping SMBlockActionBlock)
    {
        self.block = aBlock
    }
    
    open func performBlockFrom(sender aSender: SenderType)
    {
        self.block(aSender)
    }
}
