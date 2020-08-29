//
//  Atomic.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation

public struct Atomic {
    private let lock: NSLock = NSLock()
    
    public func atomic(_ execute: () -> Void) {
        lock.lock() ;defer { lock.unlock() }
        execute()
    }
}
