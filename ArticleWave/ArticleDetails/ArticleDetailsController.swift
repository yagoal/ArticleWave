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
    private let image: UIImage

    var coordinator: AppCoordinator?

    // MARK: - Lifecycle
    override func loadView() {
        view = ArticleDetailsView(
            article: article,
            image: image,
            onGoToSitePressed: weakify { $0.coordinator?.triggerOpenURL(for: $1) }
        )
    }

    // MARK: - Init
    init(article: Article, image: UIImage) {
        self.article = article
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
