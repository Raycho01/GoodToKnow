//
//  FeedCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.05.24.
//

import Foundation
import UIKit
import VerticalCardSwiper

protocol FeedCellDelegate: AnyObject {
    func didTapReadLater()
}

final class FeedCell: CardCell {
    
    static let identifier = "FeedCell"
    
    weak var delegate: FeedCellDelegate?
    
    private lazy var backgroundOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MainColors.accentColor?.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getCopperplateFont(size: 20)
        label.textColor = .MainColors.primaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        let placeholderText = "Here's the source of the article"
        label.text = placeholderText
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var readLaterButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "clock"), for: .normal)
        button.addTarget(self, action: #selector(didTapReadLater), for: .touchUpInside)
        button.setDimensions(width: 30, height: 30)
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = UIColor.MainColors.primaryText
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(width: 240, height: 240)
        imageView.roundCornersWithBorder(radius: 120, color: UIColor.white.cgColor, width: 3)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isSkeletonable = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .MainColors.primaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .MainColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        let placeholderText = "Author of the article"
        label.text = placeholderText
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .MainColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        let placeholderText = "00.00.0000"
        label.text = placeholderText
        return label
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        let placeholderText = "That's the place of the description of this article. Usually it's a multiline text with some information about the article."
        label.text = placeholderText
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        let placeholderText = "That's the content of this article. It's like the description."
        label.text = placeholderText
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.isSkeletonable = true
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
        isSkeletonable = true
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        contentView.addSubview(backgroundOverlayView)
        backgroundOverlayView.anchor(top: contentView.topAnchor,
                                     leading: contentView.leadingAnchor,
                                     trailing: contentView.trailingAnchor)
        backgroundOverlayView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        backgroundOverlayView.addSubview(sourceLabel)
        sourceLabel.anchor(top: backgroundOverlayView.topAnchor, topConstant: 20,
                           leading: backgroundOverlayView.leadingAnchor, leadingConstant: 20)
        
        backgroundOverlayView.addSubview(readLaterButton)
        readLaterButton.anchor(trailing: backgroundOverlayView.trailingAnchor, trailingConstant: 20)
        readLaterButton.centerYAnchor.constraint(equalTo: sourceLabel.centerYAnchor).isActive = true
        sourceLabel.trailingAnchor.constraint(lessThanOrEqualTo: readLaterButton.leadingAnchor).isActive = true
        
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
    
    func configure(with article: NewsArticle?) {
        
        guard let article = article else {
            showSkeletonView(show: true)
            return
        }
        showSkeletonView(show: false)
        
        sourceLabel.text = article.source.name
        imageView.setImage(with: article.urlToImage ?? "")
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = article.publishedAt?.formatted()
        descriptionLabel.text = article.description
        contentLabel.text = article.content
    }
    
    private func showSkeletonView(show: Bool) {
        if show {
            showGradientSkeleton(usingGradient: .init(baseColor: .silver, secondaryColor: .clouds), animated: true, delay: .zero, transition: .crossDissolve(0.25))
        } else {
            hideSkeleton()
        }
    }
    
    @objc func didTapReadLater() {
        delegate?.didTapReadLater()
    }
}
