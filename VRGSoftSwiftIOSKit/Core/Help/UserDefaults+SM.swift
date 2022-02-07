//
//  UserDefaults+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 3/29/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import Foundation

public extension SMWrapper where Base: UserDefaults {

    func value<Value: Codable>(forKey key: String) -> Value? {
        if let data: Data  = base.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(Value.self, from: data)
        } else {
            return nil
        }
    }

    func set<Value: Codable>(_ value: Value, forKey key: String) {
        if let data: Data = try? JSONEncoder().encode(value) {
            base.set(data, forKey: key)
        }
    }

    func clearValue(forKey key: String) {
        base.removeObject(forKey: key)
    }
}


extension UserDefaults: SMCompatible { }
