//
//  ArticlesListView.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import UIKit

protocol ArticlesViewDelegate: AnyObject {
    func didSelectArticle(_ article: Article, withImage imageView: UIImageView)
    func didSelectCountry(_ country: String)
}

final class ArticlesListView: UIView {
    weak var delegate: ArticlesViewDelegate?

    // MARK: - Properties
    private lazy var headerView: ArticlesHeaderView = {
        let view = ArticlesHeaderView(
            didSelectCountry: { [weak self] in self?.delegate?.didSelectCountry($0) }
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var articlesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.identifier)
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
        addSubview(headerView)
        addSubview(articlesTableView)
        configureConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(headerView)
        addSubview(articlesTableView)
        configureConstraint()
    }
    
    // MARK: - Private Methods
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            articlesTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            articlesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articlesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            articlesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }


    // MARK: - Public Methods
    func reloadData() {
        articlesTableView.reloadData()
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ArticleListTableViewCell else { return }
        let article = articles[indexPath.row]

        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            if let image = images[url] {
                cell.updateImage(with: image)
            } else {
                cell.updateImage(with: UIImage(named: "imageNotFound"))
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        let imageView: UIImageView = .defaultImageView
        guard
            let urlString = article.urlToImage,
            let url = URL(string: urlString),
            let image = images[url]
        else {
            delegate?.didSelectArticle(article, withImage: imageView)
            return
        }

        imageView.image = image

        delegate?.didSelectArticle(article, withImage: imageView)
    }
}
