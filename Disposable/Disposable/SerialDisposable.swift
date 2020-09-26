//
//  SerialDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation
import Atomicity

public class SerialDisposable: Disposable {
        
    private var _isDisposed: UnsafeAtomicBool = UnsafeAtomicBool()
    
    private let _disposable: Atomic<Disposable> = Atomic()
    
    public var isDisposed: Bool {
        _isDisposed.bool
    }
    
    public init() {}
    
    deinit {
        _isDisposed.deinititalize()
    }
    
    public var disposable: Disposable? {
        get {
            return _disposable.value
        }
        set {
            guard !self.isDisposed else {
                newValue?.dispose()
                return
            }
            _disposable.swap(newValue)?.dispose()
        }
    }
    
    public func dispose() {
        guard !self.isDisposed else {
            return
        }
        if _isDisposed.true() {
            _disposable.value?.dispose()
        }
    }
}
