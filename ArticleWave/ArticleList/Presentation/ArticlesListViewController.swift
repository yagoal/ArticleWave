//
//  ArticlesListViewController.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit
import Combine

final class ArticlesListViewController: UIViewController {

    // MARK: - Properties
    private lazy var rootView = ArticlesListView()
    private let viewModel = ArticlesListViewModel()
    private var cancellables: Set<AnyCancellable> = []

    var coordinator: AppCoordinator?

    // MARK: - Subviews
    private let activityIndicator = UIActivityIndicatorView(style: .large) .. {
        $0.accessibilityIdentifier = "activityIndicator"
        $0.hidesWhenStopped = true
    }

    private lazy var errorView = ErrorView(
        onRetry: weakify { $0.viewModel.fetchArticles($0.viewModel.currentCountry) }
    ) .. {
        $0.alpha = 0
    }

    // MARK: - View Lifecycle
    override func loadView() {
        view = rootView
        setupAuxiliarViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        setupBindings()
        viewModel.fetchArticles()
        setupNavigation()
    }
    
    // MARK: - Setup Methods
    private func setupNavigation() {
        navigationController?.isToolbarHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }

    private func setupAuxiliarViews() {
        [activityIndicator, errorView].forEach(rootView.addSubview(_:))

        activityIndicator
            .centerX(to: view.centerXAnchor)
            .centerY(to: view.centerYAnchor)

        errorView
            .top(to: view.topAnchor)
            .leading(to: view.leadingAnchor)
            .trailing(to: view.trailingAnchor)
            .bottom(to: view.bottomAnchor)
    }

    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.sinkState(state)
            }
            .store(in: &cancellables)
    }

    private func sinkState(_ state: ArticlesListState) {
        switch state {
        case .idle:
            hideError()
            hideLoading()
            rootView.articles = []
        case .loading:
            showLoading()
        case .loaded(let articles):
            hideError()
            hideLoading()
            rootView.articles = articles
        case .error:
            hideLoading()
            showError()
        }
    }

    // MARK: Loading Behavior
    private func showLoading() {
        hideError()
        rootView.setVisibleContent(isHidden: true)
        activityIndicator.startAnimating()
    }

    private func hideLoading() {
        rootView.setVisibleContent(isHidden: false)
        activityIndicator.stopAnimating()
    }

    // MARK: - Error Handling
    private func showError() {
        errorView.alpha = 1
    }

    private func hideError() {
        errorView.alpha = 0
    }
}

// MARK: - ArticlesViewDelegate
extension ArticlesListViewController: ArticlesViewDelegate {
    func didSelectCountry(_ country: String,_ isRefreshing: Bool) {
        viewModel.fetchArticles(country, isRefreshing)
    }

    func didSelectArticle(_ article: Article) {
        coordinator?.triggerDetails(for: article)
    }
}
