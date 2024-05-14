//
//  ArticleStartViewRepresentable.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import SwiftUI

struct ArticleStartViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(rootViewController: navigationController)
        coordinator.start()
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
