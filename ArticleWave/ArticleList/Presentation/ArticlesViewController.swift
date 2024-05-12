//
//  ArticlesViewController.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit
import Combine

final class ArticlesViewController: UIViewController {

    // MARK: - Properties
    private lazy var rootView = ArticlesView()
    private var viewModel: ArticlesViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - View Lifecycle
    override func loadView() {
        view = rootView
        setupActivityIndicator()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ArticlesViewModel()
        setupBindings()
        viewModel.fetchArticles()
    }

    // MARK: - Setup Methods
    private func setupActivityIndicator() {
        rootView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: rootView.centerYAnchor)
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
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
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
