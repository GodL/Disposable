//
//  CompoundDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation

public class CompoundDisposable: Disposable {
    private let lock: Atomic = Atomic()
    
    private var _isDisposed: Bool = false
    
    private var _disposables: [Disposable] = []
    
    public var isDisposed: Bool {
        lock.atomic {
            _isDisposed
        }
    }
    
    public init() {}
    
    public func dispose() {
        guard !isDisposed else {
            return
        }
        
        let disposables: [Disposable]? = lock.atomic {
            guard !self._isDisposed else {
                return nil as [Disposable]?
            }
            let disposables = self._disposables
            self._isDisposed = true
            return disposables
        }
        disposables?.dispose()
    }
}

extension CompoundDisposable {
    public convenience init(_ disposables: Disposable...) {
        self.init()
        _disposables += disposables
    }
    
    public convenience init(_ disposables: [Disposable]) {
        self.init()
        _disposables += disposables
    }
}

extension CompoundDisposable {
    
    public func add(_ disposables: Disposable...) {
        add(disposables)
    }
    
    public func add(_ disposables: [Disposable]) {
        let disposables = disposables.filter {
            !$0.isDisposed
        }
        
        guard disposables.count > 0 else {
            return
        }
        
        var shouldDisposed: Bool = false
        
        lock.atomic {
            if isDisposed {
                shouldDisposed = true
            }else {
                _disposables.append(contentsOf: disposables)
            }
        }
        if shouldDisposed {
            disposables.dispose()
        }
        
    }
}
