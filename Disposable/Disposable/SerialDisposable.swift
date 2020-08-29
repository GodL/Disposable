//
//  SerialDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation


public class SerialDisposable: Disposable {
    
    private let lock: Atomic = Atomic()
    
    private var _isDisposed: Bool = false
    
    private var _disposable: Disposable?
    
    public var isDisposed: Bool {
        lock.atomic { _isDisposed }
    }
    
    public init() {}
    
    public var disposable: Disposable? {
        get {
            return lock.atomic { self.disposable }
        }
        set {
            guard !self.isDisposed else {
                newValue?.dispose()
                return
            }
            lock.atomic { self._disposable }?.dispose()
        }
    }
    
    public func dispose() {
        guard !self.isDisposed else {
            return
        }
        
        let current: Disposable? = lock.atomic {
            guard !self._isDisposed else {
                return nil
            }
            self._isDisposed = true
            return self.disposable
        }
        current?.dispose()
    }
}
