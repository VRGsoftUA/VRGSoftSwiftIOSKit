//
//  SMCellProtocol.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public protocol SMCellProtocol : NSObjectProtocol
{
    var cellData: SMCellData? { get set }
    func setupCellData(_ aCellData: SMCellData!) -> Void
}
