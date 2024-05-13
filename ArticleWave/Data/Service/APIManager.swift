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
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class APIManager: APIManagerType {
    // MARK: - Singleton
    static let shared = APIManager()

    // MARK: - Properties
    private let apiKey = "9510fe8ad20f4ccfbb624315a4cf3465"
    private let baseURL = "https://newsapi.org/v2/top-headlines"

    // MARK: - Article Fetching
    func fetchArticles(_ country: String) -> AnyPublisher<[Article]?, Error> {
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
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in UIImage(data: data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
