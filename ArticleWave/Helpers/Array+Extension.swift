//
//  Array+Extension.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import Foundation

extension Array {
    subscript (safeIndex index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
