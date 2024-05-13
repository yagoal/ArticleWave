//
//  ArticlesListHeaderView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import UIKit

final class ArticlesHeaderView: UIView {
    private let didSelectCountry: (_ country: String) -> Void
    private var selectedButton: UIButton?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notícias"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let countries = [
        ("🇧🇷", "br"),
        ("🇵🇹", "pt"),
        ("🇦🇷", "ar"),
        ("🇺🇸", "us"),
        ("🇬🇧", "gb"),
    ]

    init(didSelectCountry: @escaping (_ country: String) -> Void) {
        self.didSelectCountry = didSelectCountry
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setDefaultSelection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .systemBackground

        addSubview(titleLabel)
        addSubview(buttonStackView)

        for (emoji, code) in countries {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitle(emoji, for: .normal)
            button.accessibilityIdentifier = code
            button.addTarget(self, action: #selector(countryButtonPressed(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 20
            button.layer.masksToBounds = true
            button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
            buttonStackView.addArrangedSubview(button)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),

            bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10)
        ])
    }

    private func setDefaultSelection() {
        if let firstButton = buttonStackView.arrangedSubviews.first as? UIButton {
            countryButtonPressed(firstButton)
        }
    }

    @objc private func countryButtonPressed(_ sender: UIButton) {
        if let selectedButton = selectedButton {
            selectedButton.backgroundColor = .systemBlue.withAlphaComponent(0.8) // Reset the previous selected button
        }

        selectedButton = sender // Set the new selected button
        selectedButton?.backgroundColor = .systemGreen // Change color for selection

        guard let country = sender.accessibilityIdentifier else { return }
        didSelectCountry(country)
    }
}
