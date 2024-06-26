//
//  CascadeOperator.swift
//  ArticleWave
//
//  Created by Yago Pereira on 14/5/24.
//

import Foundation

prefix operator ..
infix operator ..: MultiplicationPrecedence

/// Custom operator that lets you configure an instance inline
///
/// ```swift
/// lazy var view = UIImageView() .. {
///    $0.backgroundColor = .red
///    $0.image = Asset.myAwesomeView.image
/// }
/// ```
@discardableResult
public func .. <T>(object: T, configuration: (inout T) -> Void) -> T {
    var object = object
    configuration(&object)
    return object
}
