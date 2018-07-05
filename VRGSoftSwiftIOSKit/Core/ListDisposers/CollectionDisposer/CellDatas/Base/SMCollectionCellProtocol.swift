//
//  SMCollectionCellProtocol.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

public protocol SMCollectionCellProtocol: class
{
    var cellData: SMCollectionCellData? { get set }
    func setupCellData(_ aCellData: SMCollectionCellData)
}
