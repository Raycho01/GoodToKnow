//
//  NewsDetailsViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 25.02.24.
//

import Foundation
import UIKit

final class NewsDetailsViewController: UIViewController {
    
    // MARK: Properties
    private let newsArticle: NewsArticle
    
    // MARK: UI elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var internetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "safari"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapInternetButton), for: .touchUpInside)
        button.tintColor = UIColor.MainColors.primaryText
        button.setDimensions(width: 40, height: 40)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle
    
    init(newsArticle: NewsArticle) {
        self.newsArticle = newsArticle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Configuration
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(contentView)
        contentView.fillSuperview()
        contentView.centerInSuperview()
        contentView.setDimensions(width: scrollView.frame.width, height: scrollView.frame.height)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(vStackView)
        contentView.addSubview(internetButton)
        
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.anchor(top: view.topAnchor,
                         bottom: vStackView.topAnchor, bottomConstant: 20)
        
        
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.anchor(top: contentView.topAnchor, topConstant: 20,
                          bottom: vStackView.topAnchor, bottomConstant: 20,
                          leading: contentView.leadingAnchor, leadingConstant: 20,
                          trailing: contentView.trailingAnchor, trailingConstant: 20)
        
        
        vStackView.anchor(leading: contentView.leadingAnchor, leadingConstant: 20,
                          trailing: contentView.trailingAnchor, trailingConstant: 20)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(contentLabel)
        vStackView.addArrangedSubview(authorLabel)
        vStackView.addArrangedSubview(sourceLabel)
        
        
        internetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        internetButton.anchor(top: vStackView.bottomAnchor, topConstant: 40,
                              bottom: contentView.bottomAnchor)
    
        makeTabBarTransparent()
    }
    
    private func makeTabBarTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func populateData() {
        authorLabel.text = "Author: \(newsArticle.author ?? "Unknown")"
        sourceLabel.text = "Source: \(newsArticle.source.name ?? "Unknown")"
        titleLabel.text = newsArticle.title
        descriptionLabel.text = newsArticle.description
        contentLabel.text = newsArticle.content
        setupImageView(with: newsArticle.urlToImage ?? "")
    }
    
    private func setupImageView(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        url.fetchImage { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    @objc private func didTapInternetButton() {
        let webViewController = WebViewController(urlString: newsArticle.url ?? "")
        navigationController?.present(webViewController, animated: true)
    }
}
