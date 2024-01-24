//
//  HotNewsTableViewCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation
import UIKit

import UIKit

final class HotNewsTableViewCell: UITableViewCell {

    static let identifier = "HotNewsTableViewCell"

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .MainColors.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .MainColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .MainColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(newsImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(dateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 16.0 / 12.0),
            newsImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            authorLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            dateLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }

    func configure(with article: NewsArticle) {
        loadImage(from: article.urlToImage ?? "")
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = article.publishedAt?.description
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.newsImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}

