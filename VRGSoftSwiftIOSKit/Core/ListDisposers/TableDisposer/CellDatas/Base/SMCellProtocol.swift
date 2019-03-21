//
//  SMCellProtocol.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public protocol SMCellProtocol: class {
    
    var cellData: SMListCellData? { get set }
    
    func setupCellData(_ aCellData: SMListCellData)
}
