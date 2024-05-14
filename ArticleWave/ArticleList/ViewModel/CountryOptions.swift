//
//  CountryOptions.swift
//  ArticleWave
//
//  Created by Yago Pereira on 14/5/24.
//

import Foundation

enum CountryOptions: String, CaseIterable {
    case brazil = "br"
    case portugal = "pt"
    case argentina = "ar"
    case usa = "us"
    case uk = "gb"
    
    var emoji: String {
        switch self {
        case .brazil: "🇧🇷"
        case .portugal: "🇵🇹"
        case .argentina: "🇦🇷"
        case .usa: "🇺🇸"
        case .uk: "🇬🇧"
        }
    }
}
