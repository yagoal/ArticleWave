//
//  ArticleDetailsController.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import UIKit

final class ArticleDetailsViewController: UIViewController {
    // MARK: - Properties
    private let article: Article
    private let imageView: UIImageView

    var coordinator: AppCoordinator?

    // MARK: - Lifecycle
    override func loadView() {
        view = ArticleDetailsView(
            article: article,
            imageView: imageView,
            onGoToSitePressed: { [weak self] url in
                guard let self else { return }
                coordinator?.triggerOpenURL(for: url)
            }
        )
    }

    // MARK: - Init
    init(article: Article, imageView: UIImageView) {
        self.article = article
        self.imageView = imageView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
