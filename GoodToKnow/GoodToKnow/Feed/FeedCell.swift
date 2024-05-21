//
//  FeedCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.05.24.
//

import Foundation
import UIKit
import VerticalCardSwiper

final class FeedCell: CardCell {
    
    static let identifier = "FeedCell"
    
    private let backgroundOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MainColors.headerBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 80, height: 80)
        imageView.roundCornersWithBorder(radius: 40, color: UIColor.MainColors.veryLightBackground?.cgColor ?? UIColor.white.cgColor)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .MainColors.primaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .MainColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .MainColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor.MainColors.primaryBackground
        layer.cornerRadius = 20
        clipsToBounds = true
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        contentView.addSubview(backgroundOverlayView)
        backgroundOverlayView.anchor(top: contentView.topAnchor,
                                     leading: contentView.leadingAnchor,
                                     trailing: contentView.trailingAnchor)
        backgroundOverlayView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        contentView.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: backgroundOverlayView.bottomAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(authorLabel)
        vStack.addArrangedSubview(dateLabel)
        vStack.addArrangedSubview(descriptionLabel)
        vStack.addArrangedSubview(contentLabel)
        
        vStack.anchor(top: imageView.bottomAnchor, topConstant: 40,
                      bottom: contentView.bottomAnchor, bottomConstant: 40,
                      leading: contentView.leadingAnchor, leadingConstant: 20,
                      trailing: contentView.trailingAnchor, trailingConstant: 20)
    }
    
    func configure(with article: NewsArticle) {
        imageView.setImage(with: article.urlToImage ?? "")
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = article.publishedAt?.formatted()
        descriptionLabel.text = article.description
        contentLabel.text = article.content
    }
}
