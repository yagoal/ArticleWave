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
    var coordinator: AppCoordinator?

    // MARK: - Lifecycle
    override func loadView() {
        view = ArticleDetailsView(
            article: article,
            onGoToSitePressed: weakify { $0.coordinator?.triggerOpenURL(for: $1) }
        )
    }

    // MARK: - Init
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
