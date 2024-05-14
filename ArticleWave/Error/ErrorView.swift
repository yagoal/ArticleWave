//
//  ErrorView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 13/5/24.
//

import UIKit

final class ErrorView: UIView {

    // MARK: - Properties
    private let onRetry: () -> Void

    // MARK: - Subviews
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "error")

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Ocorreu um Erro"

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "Não foi possível completar sua solicitação."
        label.numberOfLines = 0
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tentar Novamente", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10

        button.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(onRetry: @escaping () -> Void) {
        self.onRetry = onRetry
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        backgroundColor = .white
        addSubview(errorImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(retryButton)
        setupForUITesting()
    }

    private func setupForUITesting() {
        retryButton.accessibilityIdentifier = "errorRetryButton"
        subtitleLabel.accessibilityIdentifier = "errorSubtitleLabel"
        titleLabel.accessibilityIdentifier = "errorTitleLabel"
        errorImageView.accessibilityIdentifier = "errorImageView"
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -120),
            errorImageView.widthAnchor.constraint(equalToConstant: 100),
            errorImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            retryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            retryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func retryAction() {
        onRetry()
    }
}
