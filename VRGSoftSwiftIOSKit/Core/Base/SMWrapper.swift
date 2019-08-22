//
//  SMWrapper.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/22/19.
//  Copyright © 2019 OLEKSANDR SEMENIUK. All rights reserved.
//

public class SMWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        
        self.base = base
    }
}

public protocol SMCompatible {
    
    associatedtype SMBase
    
    static var sm: SMWrapper<SMBase>.Type { get set }
    
    var sm: SMWrapper<SMBase> { get set }
}

extension SMCompatible {
    
    public static var sm: SMWrapper<Self>.Type {
        get {
            return SMWrapper<Self>.self
        }
        set { } // swiftlint:disable:this unused_setter_value
    }
    
    public var sm: SMWrapper<Self> {
        get {
            return SMWrapper(self)
        }
        set { } // swiftlint:disable:this unused_setter_value
    }
}
