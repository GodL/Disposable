//
//  Disposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation

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
    private let lock: Atomic = Atomic()
    
    private var action: DisposableAction?
        
    public var isDisposed: Bool {
        action == nil
    }
    
    public required init(_ action: @escaping DisposableAction) {
        self.action = action
    }
    
    public func dispose() {
        guard !self.isDisposed else {
            return
        }
        let current: DisposableAction? = lock.atomic {
            let action = self.action
            self.action = nil
            return action
        }
        current?()
    }
}
