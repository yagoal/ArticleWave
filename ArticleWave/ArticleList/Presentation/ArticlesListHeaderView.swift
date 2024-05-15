//
//  ArticlesListHeaderView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import UIKit

final class ArticlesHeaderView: UIView {
    // MARK: - Properties
    private let didSelectCountry: (_ country: String) -> Void
    private var selectedButton: UIButton?

    // MARK: - Subviews
    private let titleLabel = UILabel() .. {
        $0.text = "Notícias"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.accessibilityIdentifier = "newsTitleIdentifier"
    }

    private let buttonStackView = UIStackView() .. {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }

    // MARK: - Init
    init(didSelectCountry: @escaping (_ country: String) -> Void) {
        self.didSelectCountry = didSelectCountry
        super.init(frame: .zero)
        setupViews()
        configureConstraint()
        setupDefaultSelection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(buttonStackView)

        CountryOptions.allCases
            .map(makeCountryButtons)
            .forEach(buttonStackView.addArrangedSubview(_:))
    }

    private func makeCountryButtons(country: CountryOptions) -> UIButton {
        UIButton(type: .system) .. {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            $0.setTitle(country.emoji, for: .normal)
            $0.accessibilityIdentifier = "countryButton_\(country.rawValue)"
            $0.addTarget(self, action: #selector(countryButtonPressed(_:)), for: .touchUpInside)
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        }
    }

    private func configureConstraint() {
        titleLabel
            .top(to: topAnchor, constant: 10)
            .centerX(to: centerXAnchor)
            .height(30)

        buttonStackView
            .top(to: titleLabel.bottomAnchor, constant: 10)
            .leading(to: leadingAnchor, constant: 10)
            .trailing(to: trailingAnchor, constant: -10)
            .height(40)
            .bottomAnchor(to: bottomAnchor, constant: -10)
    }

    private func setupDefaultSelection() {
        if let firstButton = buttonStackView.arrangedSubviews.first as? UIButton {
            countryButtonPressed(firstButton)
        }
    }

    // MARK: - Actions
    @objc private func countryButtonPressed(_ sender: UIButton) {
        if let selectedButton = selectedButton {
            selectedButton.backgroundColor = .systemBlue.withAlphaComponent(0.8)
            selectedButton.layer.borderWidth = 0
            selectedButton.accessibilityValue = "deselected"
        }

        selectedButton = sender
        selectedButton?.backgroundColor = .systemGreen
        selectedButton?.layer.borderWidth = 3
        selectedButton?.layer.borderColor = UIColor.systemYellow.cgColor
        selectedButton?.accessibilityValue = "selected"

        guard let country = sender
            .accessibilityIdentifier?
            .components(separatedBy: "_")
            .last
        else {
            return
        }

        didSelectCountry(country)
    }
}
