//
//  SerialDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation


public class SerialDisposable: Cancelable {
    
    private let lock: Atomic = Atomic()
    
    private var _isDisposed: Bool = false
    
    private var _disposable: DisposableType?
    
    public var isDisposed: Bool {
        var isDisposed = false
        self.lock.atomic {
            isDisposed = _isDisposed
        }
        return isDisposed
    }
    
    public var disposable: DisposableType? {
        get {
            var _disposable :DisposableType?
            self.lock.atomic {
                _disposable = self.disposable
            }
            return _disposable
        }
        set {
            guard !self.isDisposed else {
                newValue?.dispose()
                return
            }
            
            var _current: DisposableType?
            self.lock.atomic {
                _current = self._disposable
                self._disposable = newValue
            }
            _current?.dispose()
        }
    }
    
    public func dispose() {
        guard !self.isDisposed else {
            return
        }
        var current: DisposableType?
        
        self.lock.atomic {
            _isDisposed = true
            current = self._disposable
        }
        current?.dispose()
    }
}
