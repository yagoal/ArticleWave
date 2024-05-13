//
//  ArticleDetailsController.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import UIKit

final class ArticleDetailsViewController: UIViewController {
    private let article: Article
    private let imageView: UIImageView

    override func loadView() {
        view = ArticleDetailsView(
            article: article,
            imageView: imageView,
            onGoToSitePressed: { [weak self] url in
                self?.onGoToSiteAction(url)
            }
        )
    }

    init(article: Article, imageView: UIImageView) {
        self.article = article
        self.imageView = imageView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func onGoToSiteAction(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
