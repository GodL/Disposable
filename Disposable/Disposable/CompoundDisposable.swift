//
//  CompoundDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation

public class CompoundDisposable: Cancelable {
    private let lock: Atomic = Atomic()
    
    private var _isDisposed: Bool = false
    
    private var _disposables: [Cancelable] = []
    
    public var isDisposed: Bool {
        _isDisposed
    }
    
    public func dispose() {
        guard !isDisposed else {
            return
        }
        
        let disposables = _disposables
        self.lock.atomic {
            _isDisposed = true
        }
        disposables.dispose()
    }
}

extension CompoundDisposable {
    public convenience init(_ disposables: Cancelable...) {
        self.init()
        _disposables += disposables
    }
    
    public convenience init(_ disposables: [Cancelable]) {
        self.init()
        _disposables += disposables
    }
}

extension CompoundDisposable {
    
    public func add(_ disposables: Cancelable...) {
        add(disposables)
    }
    
    public func add(_ disposables: [Cancelable]) {
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