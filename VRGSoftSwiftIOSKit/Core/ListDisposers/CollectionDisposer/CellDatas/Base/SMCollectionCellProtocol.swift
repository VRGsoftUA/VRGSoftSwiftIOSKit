//
//  SMCollectionCellProtocol.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public protocol SMCollectionCellProtocol: class
{
    var cellData: SMCollectionCellData? { get set }
    func setupCellData(_ aCellData: SMCollectionCellData)
}
