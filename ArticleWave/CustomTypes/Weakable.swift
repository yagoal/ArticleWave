//
//  Weakable.swift
//  ArticleWave
//
//  Created by Yago Pereira on 14/5/24.
//

import Foundation

protocol Weakable: AnyObject {}

extension NSObject: Weakable {}

extension Weakable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        { [weak self] in
            guard let self else { return }
            code(self)
        }
    }

    func weakify<A>(_ code: @escaping (Self, A) -> Void) -> (A) -> Void {
        { [weak self] a in
            guard let self else { return }
            code(self, a)
        }
    }

    func weakify<A, B>(_ code: @escaping (Self, A, B) -> Void) -> (A, B) -> Void {
        { [weak self] a, b in
            guard let self else { return }
            code(self, a, b)
        }
    }
}
