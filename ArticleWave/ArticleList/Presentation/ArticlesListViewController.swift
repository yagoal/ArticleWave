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

    // MARK: - Subviews
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0
        return blurEffectView
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
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.articles = self?.viewModel.articles ?? []
            }
            .store(in: &cancellables)

        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.images = self?.viewModel.images ?? [:]
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.blurEffectView.alpha = 0.9
                } else {
                    self.activityIndicator.stopAnimating()
                    self.blurEffectView.alpha = 0
                }
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showError(message: message)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Error Handling
    private func showError(message: String) {
        print("Error occurred: \(message)")
    }
}

extension ArticlesListViewController: ArticlesViewDelegate {
    func didSelectCountry(_ country: String) {
        viewModel.fetchArticles(country)
    }

    func didSelectArticle(_ article: Article, withImage imageView: UIImageView) {
        let detailViewController = ArticleDetailsViewController(
            article: article,
            imageView: imageView
        )

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
