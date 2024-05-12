//
//  ArticleCollectionViewCell.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit

final class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"

    private var articleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.image = UIImage(named: "imageNotFound")
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    private var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        return imageView
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [articleImage, labelsStackView, chevronImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentStackView)
        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        articleImage.image = UIImage(named: "imageNotFound")
    }

    private func applyConstraints() {
        setupContentStackViewConstraints()
        setupChevronImageViewConstraints()
        setupIconViewConstraints()
        setupLabelsConstraints()
    }

    private func setupContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    private func setupChevronImageViewConstraints() {
        chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
    }

    private func setupIconViewConstraints() {
        NSLayoutConstraint.activate([
            articleImage.widthAnchor.constraint(equalToConstant: 80),
            articleImage.heightAnchor.constraint(equalToConstant: 80),
        ])
    }

    private func setupLabelsConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: labelsStackView.widthAnchor),
            authorLabel.widthAnchor.constraint(lessThanOrEqualTo: labelsStackView.widthAnchor),
            descriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: labelsStackView.widthAnchor),
        ])
    }

    func configure(with article: Article) {
        titleLabel.text = article.title

        if let author = article.author {
            authorLabel.text = "Author: \(author)"
        }

        descriptionLabel.text = article.description
    }

    func updateImage(with image: UIImage?) {
        articleImage.image = image
    }
}
