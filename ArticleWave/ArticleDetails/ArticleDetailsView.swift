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
    private let imageView: UIImageView
    private let onGoToSitePressed: (URL) -> Void

    // MARK: - Subviews
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = article.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var goToSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Saiba mais", for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToSitePressed), for: .touchUpInside)
        return button
    }()

    private lazy var contentLabel: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 5
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = article.content ?? "Artigo sem conteúdo"
        if article.content == nil {
            label.textAlignment = .center
        }
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.systemGray5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var articleImageView: UIImageView = {
        let imageView = self.imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var publicationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    init(
        article: Article,
        imageView: UIImageView,
        onGoToSitePressed: @escaping (URL) -> Void
    ) {
        self.article = article
        self.imageView = imageView
        self.onGoToSitePressed = onGoToSitePressed
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupForUITesting()
        if let dateString = DateFormatter.string(fromISO: article.publishedAt, to: "dd MMM yyyy") {
            publicationDateLabel.text = "Publicado em: \(dateString)"
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(articleImageView)
        stackView.addArrangedSubview(publicationDateLabel)
        stackView.addArrangedSubview(contentLabel)
        addSubview(goToSiteButton)
    }
    
    private func setupForUITesting() {
        scrollView.accessibilityIdentifier = "articleDetailsScrollView"
        titleLabel.accessibilityIdentifier = "articleDetailsTitleLabel"
        goToSiteButton.accessibilityIdentifier = "articleDetailsGoToSiteButton"
        contentLabel.accessibilityIdentifier = "articleDetailsContentLabel"
        articleImageView.accessibilityIdentifier = "articleDetailsImageView"
        publicationDateLabel.accessibilityIdentifier = "articleDetailsPublicationDateLabel"
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: goToSiteButton.topAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            goToSiteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            goToSiteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            goToSiteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            goToSiteButton.heightAnchor.constraint(equalToConstant: 50),

            articleImageView.heightAnchor.constraint(equalToConstant: 200),
            contentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
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
