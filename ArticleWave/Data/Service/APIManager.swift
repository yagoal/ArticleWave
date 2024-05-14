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
    func fetchArticles(_ country: String) -> AnyPublisher<[Article]?, Error>

    // MARK: - Image Fetching
    func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

import Combine
import UIKit

final class APIManager: APIManagerType {
    // MARK: - Singleton
    static let shared = APIManager()

    // MARK: - Properties
    private let apiKey = "9510fe8ad20f4ccfbb624315a4cf3465"
    private let baseURL = "https://newsapi.org/v2/top-headlines"
    private let isUITesting = LaunchArgument.check(.uiTest)

    // MARK: - Article Fetching
    func fetchArticles(_ country: String = "br") -> AnyPublisher<[Article]?, Error> {
        if isUITesting {
            return loadArticlesFromLocalJSON()
        } else {
            return fetchArticlesFromNetwork(country)
        }
    }

    private func fetchArticlesFromNetwork(_ country: String) -> AnyPublisher<[Article]?, Error> {
        var components = URLComponents(string: baseURL)
        let queryItems = [URLQueryItem(name: "country", value: country), URLQueryItem(name: "apiKey", value: apiKey)]
        components?.queryItems = queryItems

        guard let url = components?.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { [weak self] element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                self?.printPrettyJSON(data: element.data)
                return element.data
            }
            .decode(type: ArticlesResponse.self, decoder: JSONDecoder())
            .map(\.articles)
            .map {
                $0?.filter { $0.title != "[Removed]" }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func printPrettyJSON(data: Data) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
            print(prettyPrintedJson)
        } else {
            print("Failed to read JSON data.")
        }
    }

    // MARK: - Image Fetching
    func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if isUITesting {
            return Just(nil).eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) ?? UIImage() }
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Load Mock JSON For UITesting
extension APIManager {
    private func loadArticlesFromLocalJSON() -> AnyPublisher<[Article]?, Error> {
        guard let url = Bundle.main.url(
            forResource: "MockArticles",
            withExtension: "json"
        ),
        let data = try? Data(contentsOf: url)
        else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        let isWithError = LaunchArgument.check(.useMockHttpRequestsWithError)
        let isWithDelay = LaunchArgument.check(.useMockHttpRequestWithDelay)
        let delay = isWithDelay ? 3 : 0

        return Just(data)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .flatMap { data -> AnyPublisher<[Article]?, Error> in
                if isWithError {
                    return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
                } else {
                    return Just(data)
                        .decode(type: ArticlesResponse.self, decoder: JSONDecoder())
                        .map(\.articles)
                        .eraseToAnyPublisher()
                }
            }
            .mapError { error -> APIError in
                print(error.localizedDescription)
                return APIError.invalidResponse
            }
            .eraseToAnyPublisher()
    }
}
