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
    private lazy var errorImageView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "error")
    }

    private lazy var titleLabel = UILabel() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "Ocorreu um Erro"
    }

    private lazy var subtitleLabel = UILabel() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.text = "Não foi possível completar sua solicitação."
        $0.numberOfLines = 0
    }

    private lazy var retryButton = UIButton(type: .system) .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Tentar Novamente", for: .normal)
        $0.backgroundColor = UIColor.systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
    }

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
        errorImageView
            .centerX(to: centerXAnchor)
            .centerY(to: centerYAnchor, constant: -120)
            .width(100)
            .height(100)

        titleLabel
            .top(to: errorImageView.bottomAnchor, constant: 20)
            .leading(to: leadingAnchor, constant: 20)
            .trailing(to: trailingAnchor, constant: -20)

        subtitleLabel
            .top(to: titleLabel.bottomAnchor, constant: 10)
            .leading(to: leadingAnchor, constant: 20)
            .trailing(to: trailingAnchor, constant: -20)

        retryButton
            .bottom(to: bottomAnchor, constant: -20)
            .leading(to: leadingAnchor, constant: 10)
            .trailing(to: trailingAnchor, constant: -10)
            .height(50)
    }

    // MARK: - Actions
    @objc private func retryAction() {
        onRetry()
    }
}
