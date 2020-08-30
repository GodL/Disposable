//
//  NonDisposable.swift
//  Disposable
//
//  Created by 李浩 on 2020/8/30.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation

public struct NonDisposable: Disposable {
    
    public static let noOp: NonDisposable = NonDisposable()
    
    public var isDisposed: Bool {
        return false
    }
    
    public init() {}
    
    public func dispose() {
        
    }
}
