//
//  SMResponse.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

open class SMResponse {
    
    open var isSuccess: Bool = false
    open var code: Int?
    open var titleMessage: String?
    open var textMessage: String?
    open var dataDictionary: [String: AnyObject] = [:]
    open var boArray: [AnyObject] = []
    open var error: Error?
    open var isCancelled: Bool = false
    
    public init() { }
}
