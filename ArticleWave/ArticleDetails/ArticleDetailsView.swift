//
//  ArticleDetailsView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import UIKit

final class ArticleDetailsView: UIView {
    // MARK: - Properties
    private let article: Article
    private let onGoToSitePressed: (URL) -> Void

    // MARK: - Subviews
    private lazy var scrollView = UIScrollView() .. {
        $0.showsVerticalScrollIndicator = false
        $0.accessibilityIdentifier = "articleDetailsScrollView"
    }

    private lazy var stackView = UIStackView() .. {
        $0.axis = .vertical
        $0.spacing = 24
    }

    private lazy var titleLabel = UILabel() .. {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.accessibilityIdentifier = "articleDetailsTitleLabel"
        $0.text = article.title
        $0.numberOfLines = 0
    }

    private lazy var goToSiteButton = UIButton(type: .system) .. {
        $0.setTitle("Saiba mais", for: .normal)
        $0.accessibilityIdentifier = "articleDetailsGoToSiteButton"
        $0.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(goToSitePressed), for: .touchUpInside)
    }

    private lazy var contentLabel = CustomLabel() .. {
        $0.accessibilityIdentifier = "articleDetailsContentLabel"
        $0.numberOfLines = 5
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.text = article.content ?? "Artigo sem conteúdo"
        if article.content == nil {
            $0.textAlignment = .center
        }
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.systemGray5
    }

    private lazy var articleImageView = UIImageView() .. {
        $0.image = .imageNotFound
        $0.accessibilityIdentifier = "articleDetailsImageView"
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private lazy var publicationDateLabel = UILabel() .. {
        $0.accessibilityIdentifier = "articleDetailsPublicationDateLabel"
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textAlignment = .center
        $0.textColor = UIColor.secondaryLabel
    }

    // MARK: - Init
    init(
        article: Article,
        onGoToSitePressed: @escaping (URL) -> Void
    ) {
        self.article = article
        self.onGoToSitePressed = onGoToSitePressed
        super.init(frame: .zero)
        setupViews()
        setupImage()
        configureConstraints()
        setupDate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        [titleLabel, articleImageView, publicationDateLabel, contentLabel]
            .forEach(stackView.addArrangedSubview(_:))

        addSubview(goToSiteButton)
    }

    private func setupImage() {
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            if let cachedImage = ImageFetcher.shared.imageCache.object(forKey: url as NSURL) {
                articleImageView.image = cachedImage
            }
        }
    }

    private func setupDate() {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: article.publishedAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none

            let dateString = dateFormatter.string(from: date)
            publicationDateLabel.text = "Publicado em: \(dateString)"
        }
    }

    private func configureConstraints() {
        scrollView
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 20)
            .leading(to: leadingAnchor, constant: 20)
            .trailing(to: trailingAnchor, constant: -20)
            .bottom(to: goToSiteButton.topAnchor, constant: -20)

        stackView
            .top(to: scrollView.contentLayoutGuide.topAnchor)
            .leading(to: scrollView.contentLayoutGuide.leadingAnchor)
            .trailing(to: scrollView.contentLayoutGuide.trailingAnchor)
            .bottom(to: scrollView.contentLayoutGuide.bottomAnchor)
            .width(equalTo: scrollView.widthAnchor)

        goToSiteButton
            .leading(to: leadingAnchor, constant: 20)
            .trailing(to: trailingAnchor, constant: -20)
            .bottom(to: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .height(50)

        articleImageView.height(200)
        contentLabel.height(greaterThanOrEqualTo: 100)
    }

    // MARK: - Actions
    @objc private func goToSitePressed() {
        if let url = URL(string: article.url) {
            onGoToSitePressed(url)
        }
    }
}

// MARK: - Custom Label
private final class CustomLabel: UILabel {
    private let contentInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += contentInsets.top + contentInsets.bottom
        contentSize.width += contentInsets.left + contentInsets.right
        return contentSize
    }

    override func sizeToFit() {
        super.sizeToFit()
        self.bounds.size = intrinsicContentSize
    }
}
