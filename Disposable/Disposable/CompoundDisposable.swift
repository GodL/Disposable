//
//  CompoundDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation
import Atomicity

public class CompoundDisposable: Disposable {
    private var _isDisposed: UnsafeAtomicBool = UnsafeAtomicBool()
    
    private let lock: SpinLock = SpinLock.make()
    
    private var _disposables: [Disposable] = []
    
    public var isDisposed: Bool {
        _isDisposed.bool
    }
    
    public init() {}
    
    deinit {
        _isDisposed.deinititalize()
    }
    
    public func dispose() {
        guard !isDisposed else { return }
        
        if _isDisposed.true() {
            lock.lock(); defer { lock.unLock() }
            _disposables.dispose()
        }
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
        guard !self.isDisposed else {
            disposables.dispose()
            return
        }
        
        if lock.tryLock() {
            _disposables.append(contentsOf: disposables)
            lock.unLock()
        }else {
            disposables.dispose()
        }
    }
}
