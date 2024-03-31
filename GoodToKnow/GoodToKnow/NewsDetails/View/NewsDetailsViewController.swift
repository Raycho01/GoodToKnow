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
        scrollView.backgroundColor = UIColor.MainColors.primaryBackground
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.MainColors.primaryText
        label.font = .boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.MainColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var originView: NewsOriginView = {
        let frame = CGRect(x: 0, y: 0, width: 350, height: 120)
        let placeholder = "Unknown"
        return NewsOriginView(frame: frame,
                              author: newsArticle.author ?? placeholder,
                              source: newsArticle.source.name ?? placeholder,
                              publishedAt: newsArticle.publishedAt?.dateAndTimeToString() ?? placeholder)
    }()
    
    private lazy var internetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "safari"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapInternetButton), for: .touchUpInside)
        button.tintColor = UIColor.MainColors.primaryText
        button.setDimensions(width: 30, height: 30)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeOriginView()
    }
    
    // MARK: Configuration
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(contentView)
        contentView.fillSuperview()
        contentView.centerInSuperview()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(vStackView)
        
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.anchor(top: view.topAnchor,
                         bottom: vStackView.topAnchor, bottomConstant: 20,
                         leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor)
        
        
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.anchor(top: contentView.topAnchor, topConstant: 20,
                          bottom: vStackView.topAnchor, bottomConstant: 20,
                          leading: contentView.leadingAnchor, leadingConstant: 20,
                          trailing: contentView.trailingAnchor, trailingConstant: 20)
        
        vStackView.anchor(bottom: contentView.bottomAnchor, bottomConstant: 20,
                          leading: contentView.leadingAnchor, leadingConstant: 20,
                          trailing: contentView.trailingAnchor, trailingConstant: 20)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(contentLabel)
        vStackView.addArrangedSubview(originView)
    
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor.MainColors.primaryText
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: internetButton)
    }
    
    private func populateData() {
        titleLabel.text = newsArticle.title
        descriptionLabel.text = newsArticle.description
        contentLabel.text = newsArticle.content
        imageView.setImage(with: newsArticle.urlToImage ?? "")
    }
    
    private func resizeOriginView() {
        originView.frame = CGRect(x: 0, y: 0, width: vStackView.frame.width, height: 120)
    }
    
    @objc private func didTapInternetButton() {
        let webViewController = WebViewController(urlString: newsArticle.url ?? "")
        navigationController?.present(webViewController, animated: true)
    }
}
