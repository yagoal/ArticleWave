//
//  ArticleListTableViewCell.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit

final class ArticleListTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"

    // MARK: - Properties
    private var article: Article?

    // MARK: - Subviews
    private lazy var articleImage = UIImageView() .. {
        $0.image = .imageNotFound
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.borderWidth = 2
    }

    private lazy var loadingIndicator = UIActivityIndicatorView(style: .medium) .. {
        $0.hidesWhenStopped = true
    }

    private lazy var titleLabel = UILabel() .. {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.numberOfLines = 0
    }

    private lazy var authorLabel = UILabel() .. {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }

    private lazy var descriptionLabel = UILabel() .. {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.numberOfLines = 2
    }

    private lazy var chevronImageView = UIImageView() .. {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .gray
    }

    private lazy var labelsStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        descriptionLabel,
        authorLabel
    ]) .. {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        articleImage,
        labelsStackView,
        chevronImageView
    ]) .. {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
    }

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
    func configure(with article: Article?) {
        guard let article = article else {
            resetCell()
            return
        }

        self.article = article

        titleLabel.text = article.title
        authorLabel.text = article.author != nil ? "Author: \(article.author!)" : nil
        descriptionLabel.text = article.description

        configureImage(with: article.urlToImage)
    }

    private func configureImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            articleImage.image = .imageNotFound
            return
        }

        articleImage.image = nil
        loadingIndicator.startAnimating()

        ImageFetcher.shared.fetch(url: url) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                loadingIndicator.stopAnimating()
                switch result {
                case .success(let image):
                    articleImage.image = image
                case .failure:
                    articleImage.image = .imageNotFound
                }
            }
        }
    }

    private func resetCell() {
        articleImage.image = nil
        titleLabel.text = ""
        authorLabel.text = ""
        descriptionLabel.text = ""
    }

    // MARK: - View Setup
    private func setupViews() {
        articleImage.addSubview(loadingIndicator)
        contentView.addSubview(contentStackView)
    }

    // MARK: - Constraints
    private func applyConstraints() {
        setupContentStackViewConstraints()
        setupChevronImageViewConstraints()
        setupIconViewConstraints()
        setupLabelsConstraints()
        loadingIndicator.centerX(to: articleImage.centerXAnchor)
        loadingIndicator.centerY(to: articleImage.centerYAnchor)
    }

    private func setupContentStackViewConstraints() {
        contentStackView
            .leading(to: contentView.leadingAnchor, constant: 10)
            .trailing(to: contentView.trailingAnchor, constant: -10)
            .top(to: contentView.topAnchor, constant: 10)
            .bottom(to: contentView.bottomAnchor, constant: -10)
    }

    private func setupChevronImageViewConstraints() {
        chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
        chevronImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setupIconViewConstraints() {
        articleImage
            .width(80)
            .height(80)

        articleImage.setContentHuggingPriority(.required, for: .horizontal)
        articleImage.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setupLabelsConstraints() {
        labelsStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        titleLabel.width(lessThanOrEqualTo: labelsStackView.widthAnchor)
        authorLabel.width(lessThanOrEqualTo: labelsStackView.widthAnchor)
        descriptionLabel.width(lessThanOrEqualTo: labelsStackView.widthAnchor)
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        resetCell()

        guard let urlString = article?.urlToImage, let url = URL(string: urlString) else {
            return
        }
        ImageFetcher.shared.cancel(url: url)
    }
}
