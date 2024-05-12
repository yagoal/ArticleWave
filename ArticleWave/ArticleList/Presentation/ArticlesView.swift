//
//  ArticlesView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit

final class ArticlesView: UIView {

    // MARK: - Properties
    private lazy var articlesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    var articles: [Article] = [] {
        didSet {
            reloadData()
        }
    }

    var images: [URL: UIImage] = [:] {
        didSet {
            reloadData()
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(articlesTableView)
        configureConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(articlesTableView)
        configureConstraint()
    }
    
    // MARK: - Private Methods
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            articlesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articlesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            articlesTableView.topAnchor.constraint(equalTo: topAnchor),
            articlesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public Methods
    func reloadData() {
        articlesTableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate
extension ArticlesView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else {
            fatalError("Unable to dequeue ArticleTableViewCell")
        }
        cell.configure(with: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ArticleTableViewCell else { return }
        let article = articles[indexPath.row]

        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            if let image = images[url] {
                cell.updateImage(with: image)
            } else {
                cell.updateImage(with: UIImage(named: "imageNotFound"))
            }
        }
    }
}
