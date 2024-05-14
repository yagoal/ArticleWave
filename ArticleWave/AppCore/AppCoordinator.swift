//
//  AppCoordinator.swift
//  ArticleWave
//
//  Created by Yago Pereira on 13/5/24.
//

import UIKit

final class AppCoordinator {
    private let rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        let articlesListViewController = ArticlesListViewController()
        articlesListViewController.coordinator = self
        rootViewController.pushViewController(articlesListViewController, animated: false)
    }

    func triggerDetails(for article: Article, with imageView: UIImageView) {
        let articleDetailsViewController = ArticleDetailsViewController(
            article: article,
            imageView: imageView
        )
        articleDetailsViewController.coordinator = self
        rootViewController.pushViewController(articleDetailsViewController, animated: true)
    }

    func triggerOpenURL(for url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
