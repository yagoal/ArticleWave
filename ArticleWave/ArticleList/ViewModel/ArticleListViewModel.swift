//
//  ArticleListViewModel.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import Combine
import UIKit

final class ArticlesListViewModel {

    // MARK: - Properties
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var images: [URL: UIImage] = [:]

    private var cancellables: Set<AnyCancellable> = []
    private let apiManager: APIManagerType

    // MARK: - Init
    init(apiManager: APIManagerType = APIManager.shared) {
        self.apiManager = apiManager
    }

    // MARK: - Public Methods
    func fetchArticles(_ country: String = "br", _ isRefreshing: Bool = false) {
        if !isRefreshing {
            isLoading = true
        }

        errorMessage = nil

        apiManager.fetchArticles(country)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] articles in
                guard let self else { return }
                self.articles = articles ?? []
                downloadImages(for: articles ?? [])
            })
            .store(in: &cancellables)
    }

    // MARK: - Private Methods
    private func downloadImages(for articles: [Article]) {
        articles.forEach { article in
            guard let imageUrlString = article.urlToImage, let url = URL(string: imageUrlString) else { return }
            fetchImage(url: url)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                    guard let image else { return }
                    self?.images[url] = image
                })
                .store(in: &cancellables)
        }
    }

    private func fetchImage(url: URL) -> AnyPublisher<UIImage?, Error> {
        apiManager.fetchImage(from: url)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
