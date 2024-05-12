//
//  APIManager.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import Combine
import Foundation
import UIKit

protocol APIManagerType {
    // MARK: - Article Fetching
    func fetchArticles() -> AnyPublisher<[Article]?, Error>

    // MARK: - Image Fetching
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class APIManager: APIManagerType {
    // MARK: - Singleton
    static let shared = APIManager()

    // MARK: - Properties
    private let apiKey = "9510fe8ad20f4ccfbb624315a4cf3465"
    private let baseURL = "https://newsapi.org/v2/top-headlines"

    // MARK: - Article Fetching
    func fetchArticles() -> AnyPublisher<[Article]?, Error> {
        var components = URLComponents(string: baseURL)

        let queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]

        components?.queryItems = queryItems

        guard let url = components?.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ArticlesResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { response in
                if let totalResults = response.totalResults {
                    print("Total results: \(totalResults)")
                }
            })
            .mapError { error in
                error
            }
            .map(\.articles)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Image Fetching
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in UIImage(data: data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
