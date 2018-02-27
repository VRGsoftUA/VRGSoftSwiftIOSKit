//
//  SMResponse.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

open class SMResponse
{
    var isSuccess: Bool = false
    var code: Int?
    var titleMessage: String?
    var textMessage: String?
    var dataDictionary: [String: AnyObject] = [:]
    var boArray: [AnyObject] = []
    var error: Error?
    var requestCancelled: Bool = false
}
