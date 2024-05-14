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
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.accessibilityIdentifier = "activityIndicator"
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.accessibilityIdentifier = "blurEffectView"
        blurEffectView.alpha = 0
        return blurEffectView
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView(
            onRetry: { [weak self] in
                guard let self else { return }
                viewModel.fetchArticles(viewModel.currentCountry)
            }
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

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
        rootView.addSubview(blurEffectView)
        rootView.addSubview(activityIndicator)
        rootView.addSubview(errorView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                hideError()
                activityIndicator.stopAnimating()
                blurEffectView.alpha = 0
                rootView.articles = viewModel.articles
            }
            .store(in: &cancellables)
        
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                rootView.images = viewModel.images
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    activityIndicator.startAnimating()
                    blurEffectView.alpha = 1
                } else {
                    activityIndicator.stopAnimating()
                    blurEffectView.alpha = 0
                }
            }
            .store(in: &cancellables)

        viewModel.$hasError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasError in
                guard let self else { return }
                if hasError {
                    showError()
                } else {
                    hideError()
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

extension ArticlesListViewController: ArticlesViewDelegate {
    func didSelectCountry(_ country: String,_ isRefreshing: Bool) {
        viewModel.fetchArticles(country, isRefreshing)
    }

    func didSelectArticle(_ article: Article, withImage imageView: UIImageView) {
        coordinator?.triggerDetails(for: article, with: imageView)
    }
}
