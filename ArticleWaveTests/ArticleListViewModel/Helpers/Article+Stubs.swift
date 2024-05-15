//
//  Article+Stubs.swift
//  ArticleWaveTests
//
//  Created by Yago Pereira on 13/5/24.
//

@testable import ArticleWave

import Foundation
import Combine

extension Article {
    static func stub(
        source: Article.Source = .init(id: "source-id", name: "source-name"),
        author: String? = "Test Author",
        title: String = "Test Title",
        description: String? = "Test Description",
        url: String = "http://example.com",
        urlToImage: String? = "http://example.com/image.png",
        publishedAt: String = "2021-05-01T12:34:56Z",
        content: String? = "Test Content"
    ) -> Article {
         Article(
            source: source,
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}

struct ArticlesResponseFactory {
    static func makeResponse(
        status: String = "ok",
        totalResults: Int = 1,
        articles: [Article]? = [Article.stub()],
        code: String? = nil,
        message: String? = nil
    ) -> ArticlesResponse {
        return ArticlesResponse(
            status: status,
            totalResults: totalResults,
            articles: articles,
            code: code,
            message: message
        )
    }

    static func makeResponsePublisher(
        response: ArticlesResponse = makeResponse(),
        delay: TimeInterval = 0,
        scheduler: DispatchQueue = .main
    ) -> AnyPublisher<[Article]?, Error> {
        Just(response)
            .delay(for: .seconds(delay), scheduler: scheduler)
            .map(\.articles)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
