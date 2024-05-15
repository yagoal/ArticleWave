//
//  ArticlesListView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit

protocol ArticlesViewDelegate: AnyObject {
    func didSelectArticle(_ article: Article)
    func didSelectCountry(_ country: String, _ isRefreshing: Bool)
}

final class ArticlesListView: UIView {
    // MARK: - Delegate
    weak var delegate: ArticlesViewDelegate?
    private var selectedCountry: String?
    // MARK: - Subviews
    private lazy var headerView = ArticlesHeaderView(
        didSelectCountry: weakify {
            $0.selectedCountry = $1
            $0.delegate?.didSelectCountry($1, false)
        }
    )

    private lazy var articlesTableView = UITableView() .. {
        $0.accessibilityIdentifier = "articlesTableView"
        $0.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.identifier)
        $0.delegate = self
        $0.dataSource = self
    }

    private lazy var refreshControl = UIRefreshControl() .. {
        $0.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }

    // MARK: - Properties
    var articles: [Article] = [] {
        didSet {
            reloadData()
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
        addSubview(articlesTableView)
        articlesTableView.refreshControl = refreshControl
        configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func configureConstraint() {
        headerView
            .top(to: topAnchor)
            .leading(to: leadingAnchor)
            .trailing(to: trailingAnchor)
            .height(100)

        articlesTableView
            .top(to: headerView.bottomAnchor)
            .leading(to: leadingAnchor)
            .trailing(to: trailingAnchor)
            .bottom(to: bottomAnchor)
    }

    private func scrollToTop() {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        articlesTableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
    }

    // MARK: - Public Methods
    func reloadData() {
        articlesTableView.reloadData()
        refreshControl.endRefreshing()
        if !articles.isEmpty {
            scrollToTop()
        }
    }
    
    func setVisibleContent(isHidden: Bool) {
        headerView.isHidden = isHidden
        articlesTableView.isHidden = isHidden
    }

    // MARK: - Actions
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        guard let selectedCountry else { return }
        delegate?.didSelectCountry(selectedCountry, true)
    }
}

// MARK: - TableView DataSource & Delegate
extension ArticlesListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.identifier, for: indexPath) as? ArticleListTableViewCell else {
            fatalError("Unable to dequeue ArticleTableViewCell")
        }
        cell.configure(with: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]

        delegate?.didSelectArticle(article)
    }
}
