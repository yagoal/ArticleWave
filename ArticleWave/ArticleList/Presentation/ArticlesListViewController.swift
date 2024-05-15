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

    private let blurEffectView = UIVisualEffectView(
        effect: UIBlurEffect(style: .light)
    ) .. {
        $0.accessibilityIdentifier = "blurEffectView"
        $0.alpha = 0
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
        [blurEffectView, activityIndicator, errorView].forEach(rootView.addSubview(_:))

        blurEffectView
            .top(to: view.topAnchor)
            .leading(to: view.leadingAnchor)
            .trailing(to: view.trailingAnchor)
            .bottom(to: view.bottomAnchor)

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
                guard let self else { return }
                switch state {
                case .idle:
                    hideError()
                    activityIndicator.stopAnimating()
                    blurEffectView.alpha = 0
                    rootView.articles = []
                case .loading:
                    activityIndicator.startAnimating()
                    blurEffectView.alpha = 1
                case .loaded(let articles):
                    hideError()
                    activityIndicator.stopAnimating()
                    blurEffectView.alpha = 0
                    rootView.articles = articles
                case .error:
                    activityIndicator.stopAnimating()
                    blurEffectView.alpha = 0
                    showError()
                }
            }
            .store(in: &cancellables)
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

    func didSelectArticle(_ article: Article, withImage imageView: UIImage) {
        coordinator?.triggerDetails(for: article, with: imageView)
    }
}
