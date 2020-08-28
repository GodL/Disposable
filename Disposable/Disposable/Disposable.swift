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

extension DisposableType {
    public func asScoped() -> ScopedDisposable {
        return ScopedDisposable(self)
    }
}

public protocol Cancelable: DisposableType {
    var isDisposed: Bool { get }
}

extension Array where Element == Cancelable {
    public func dispose() {

    }
}

public typealias DisposableAction = () -> Void

public protocol ConcreteDisposableType: Cancelable {
    init(_ action: @escaping DisposableAction)
}

public class Disposable: ConcreteDisposableType {
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
        lock.atomic {
            action!()
            action = nil
        }
    }
}
