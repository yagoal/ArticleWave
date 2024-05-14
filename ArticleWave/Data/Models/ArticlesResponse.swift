//
//  ArticlesResponse.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import Foundation

struct ArticlesResponse: Decodable {
    // MARK: - Properties
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    let code: String?
    let message: String?

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case status, totalResults, articles, code, message
    }

    // MARK: - Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        articles = try container.decodeIfPresent([Article].self, forKey: .articles) ?? []
        code = try container.decodeIfPresent(String.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)

        if status == "error" {
            throw APIError.unknownError(message: message ?? "Unknown error from API")
        }
    }
}

extension ArticlesResponse {
    init(
        status: String,
        totalResults: Int? = nil,
        articles: [Article]? = nil,
        code: String? = nil,
        message: String? = nil
    ) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
        self.code = code
        self.message = message
    }
}

struct Article: Codable {
    // MARK: - Nested Types
    struct Source: Codable {
        let id: String?
        let name: String?
    }
    
    // MARK: - Properties
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
