//
//  UIImageView+Extension.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import UIKit

extension UIImageView {
    static var defaultImageView: UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "imageNotFound")
        return imageView
    }
}
