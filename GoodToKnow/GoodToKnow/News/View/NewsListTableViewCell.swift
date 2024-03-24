//
//  HotNewsTableViewCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import UIKit

final class NewsListTableViewCell: UITableViewCell {

    static let identifier = "NewsListTableViewCell"

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isSkeletonable = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .MainColors.primaryText
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .MainColors.secondaryText
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .MainColors.secondaryText
        label.isSkeletonable = true
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
        isSkeletonable = true
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 16.0 / 16.0),
            newsImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            authorLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            dateLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with article: NewsArticle, showSkeleton: Bool) {
        loadImage(from: article.urlToImage ?? "")
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = article.publishedAt?.formatted()
        
        showSkeletonViewIfNeeded(show: showSkeleton)
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
    
    private func showSkeletonViewIfNeeded(show: Bool) {
        if show {
            showGradientSkeleton(usingGradient: .init(baseColor: .silver, secondaryColor: .clouds), animated: true, delay: .zero, transition: .crossDissolve(0.25))
        } else {
            hideSkeleton()
        }
    }
}

