//
//  String + Help.swift
//  zirtue-ios
//
//  Created by OLEKSANDR SEMENIUK on 6/22/18.
//  Copyright © 2018 zirtue. All rights reserved.
//

import Foundation

extension String
{
    func localize() -> String
    {
        return NSLocalizedString(self, comment: "")
    }
}
