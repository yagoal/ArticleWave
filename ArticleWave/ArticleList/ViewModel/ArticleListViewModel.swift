//
//  ArticleListViewModel.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import Combine
import UIKit

enum ArticlesListState {
    case idle
    case loading
    case loaded(articles: [Article])
    case error
}

final class ArticlesListViewModel: Weakable {
    // MARK: - Properties
    @Published private(set) var state: ArticlesListState = .idle
    
    private(set) var currentCountry: String = "br"
    private var cancellables: Set<AnyCancellable> = []
    private let apiManager: APIManagerType
    
    // MARK: - Init
    init(apiManager: APIManagerType = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    // MARK: - Public Methods
    func fetchArticles(_ country: String = "br", _ isRefreshing: Bool = false) {
        if !isRefreshing {
            state = .loading
        }

        currentCountry = country

        apiManager.fetchArticles(country)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: weakify { weakSelf, completion in
                switch completion {
                case .failure:
                    weakSelf.state = .error
                case .finished:
                    break
                }
            }, receiveValue:  weakify { weakSelf, articles in
                weakSelf.state = .loaded(articles: articles ?? [])
            })
            .store(in: &cancellables)
    }
}
