//
//  ArticleListViewModel.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import Combine
import UIKit

final class ArticlesViewModel {

    // MARK: - Properties
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var images: [URL: UIImage] = [:]

    private var cancellables: Set<AnyCancellable> = []
    private var apiManager: APIManagerType

    // MARK: - Init
    init(apiManager: APIManagerType = APIManager.shared) {
        self.apiManager = apiManager
    }

    // MARK: - Public Methods
    func fetchArticles() {
        isLoading = true
        errorMessage = nil

        apiManager.fetchArticles()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] articles in
                self?.articles = articles ?? []
                self?.downloadImages(for: articles ?? [])
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func downloadImages(for articles: [Article]) {
        articles.forEach { article in
            guard let imageUrlString = article.urlToImage, let url = URL(string: imageUrlString) else { return }
            fetchImage(url: url)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self?.images[url] = image
                    }
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
