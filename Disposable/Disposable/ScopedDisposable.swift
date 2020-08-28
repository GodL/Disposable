//
//  ScopedDisposable.swift
//  Disposable
//
//  Created by lihao10 on 2020/8/28.
//  Copyright © 2020 GodL. All rights reserved.
//

import Foundation

public class ScopedDisposable: DisposableType {
    private let disposable: DisposableType
    
    public required init(_ disposable: DisposableType) {
        self.disposable = disposable
    }

    public func dispose() {
        self.disposable.dispose()
    }

    deinit {
        self.dispose()
    }

}

extension ScopedDisposable {
    public convenience init(_ action: @escaping DisposableAction) {
        let disposable: Disposable = Disposable(action)
        self.init(disposable)
    }
}

extension ScopedDisposable {
    public func asScoped() -> ScopedDisposable {
        return self
    }
}
