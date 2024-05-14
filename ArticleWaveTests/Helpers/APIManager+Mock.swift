//
//  APIManager+Mock.swift
//  ArticleWaveTests
//
//  Created by Yago Pereira on 13/5/24.
//

@testable import ArticleWave

import Combine
import UIKit

final class MockAPIManager: APIManagerType {
    var expectedResponse: Result<ArticlesResponse, Error>?
    var imageResponses: [URL: UIImage] = [:]

    func fetchArticles(_ country: String) -> AnyPublisher<[Article]?, Error> {
        Future<[Article]?, Error> { promise in
            switch self.expectedResponse {
            case .success(let response):
                promise(.success(response.articles))
            case .failure(let error):
                promise(.failure(error))
            default:
                promise(.failure(APIError.unknownError(message: "No expected response set")))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        let image = imageResponses[url] ?? UIImage(named: "defaultImage")
        return Just(image).eraseToAnyPublisher()
    }
}
