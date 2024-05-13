//
//  ArticleListTableViewCell.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit

final class ArticleListTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"

    // MARK: - Subviews
    private lazy var articleImage: UIImageView = {
        let imageView = UIImageView.defaultImageView
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 2
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        return imageView
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                descriptionLabel,
                authorLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                articleImage,
                labelsStackView,
                chevronImageView
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
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

    // MARK: - View Setup
    private func setupViews() {
        contentView.addSubview(contentStackView)
    }

    // MARK: - Constraints
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

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImage.image = UIImage(named: "imageNotFound")
    }
}
