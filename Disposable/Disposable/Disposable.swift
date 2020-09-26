//
//  Disposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation
import Atomicity

public protocol DisposableType {
    func dispose()
    
    func asScoped() -> ScopedDisposable
}

public protocol Cancelable {
    var isDisposed: Bool { get }
}

extension DisposableType where Self : Cancelable {
    public func asScoped() -> ScopedDisposable {
        return ScopedDisposable(self)
    }
}

public typealias Disposable = DisposableType & Cancelable

extension Array where Element == Disposable {
    public func dispose() {
        self.forEach { $0.dispose() }
    }
}

public typealias DisposableAction = () -> Void

public protocol ConcreteDisposableType: Disposable {
    init(_ action: @escaping DisposableAction)
}

public class ConcreteDisposable: ConcreteDisposableType {
    private let _state: UnsafeAtomicBool = UnsafeAtomicBool()
    
    private let action: DisposableAction
        
    public var isDisposed: Bool {
        _state.bool
    }
    
    public required init(_ action: @escaping DisposableAction) {
        self.action = action
    }
    
    deinit {
        _state.deinititalize()
    }
    
    public func dispose() {
        guard !self.isDisposed else {
            return
        }
        if _state.true() {
            self.action()
        }
    }
}
