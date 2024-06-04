//
//  HomeViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 18.03.24.
//

import UIKit
import Combine

protocol CarouselViewModelProtocol {
    var title: String { get }
    
    func bind() -> AnyPublisher<[CarouselModel], Never>
    func fetch()
}

final class HomeViewController: UIViewController {
    
    private let headerViewModel: NewsListHeaderViewModel
    private let carouselViewModel: CarouselViewModelProtocol
    private let categories: [Category] = [.business, .entertainment, .general, .health, .science, .sports, .technology]
    
    private lazy var headerView: NewsListHeaderView = {
        let headerView = NewsListHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 8),
                           viewModel: headerViewModel)
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var introductionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageBackgroundView = UIImageView(image: UIImage(named: "home_introduction_image"))
        imageBackgroundView.contentMode = .scaleToFill
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageBackgroundView)
        imageBackgroundView.fillSuperview()
        imageBackgroundView.centerInSuperview()
        
        let introductionLabel = UILabel()
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.text = Strings.ScreenTitles.appName
        introductionLabel.numberOfLines = 0
        introductionLabel.textAlignment = .center
        introductionLabel.font = UIFont.getCopperplateFont(size: 36)
        introductionLabel.textColor = UIColor.MainColors.primaryText
        view.addSubview(introductionLabel)
        introductionLabel.fillSuperview()
        introductionLabel.centerInSuperview()
        
        return view
    }()
    
    private lazy var filtersInfoWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.MainColors.headerBackground.withAlphaComponent(0.3)
        
        let filtersInfoLabel = UILabel()
        filtersInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        filtersInfoLabel.text = Strings.HomeScreen.filtersInfo
        filtersInfoLabel.numberOfLines = 0
        filtersInfoLabel.textAlignment = .center
        filtersInfoLabel.font = .boldSystemFont(ofSize: 24)
        filtersInfoLabel.textColor = UIColor.MainColors.secondaryText
        view.addSubview(filtersInfoLabel)
        filtersInfoLabel.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return view
    }()
    
    private lazy var countryCarouselView: CarouselView = {
        let carouselView = CarouselView(viewModel: carouselViewModel, frame: CGRect(x: 0, y: 0,
                                                                                     width: view.frame.width,
                                                                                     height: 100))
        carouselView.delegate = self
        return carouselView
    }()
    
    private lazy var categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.MainColors.secondaryText
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = Strings.HomeScreen.categories
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

        return collectionView
    }()
    
    private lazy var feedInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.HomeScreen.feedInfo
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .getCopperplateFont(size: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var feedInfoWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack = UIStackView()
        vStack.axis = .horizontal
        vStack.spacing = 10
        vStack.addArrangedSubview(feedInfoLabel)
        vStack.addArrangedSubview(feedIcon)
        vStack.alignment = .center
        view.addSubview(vStack)
        vStack.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        view.backgroundColor = UIColor.MainColors.accentColor
        view.layer.cornerRadius = 20
        view.setShadow()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToFeed))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var feedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "flame")
        imageView.tintColor = UIColor.white
        imageView.setDimensions(width: 40, height: 40)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(userDidRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    init(carouselViewModel: CarouselViewModelProtocol = HomeCarouselViewModel(), headerViewModel: NewsListHeaderViewModel) {
        self.headerViewModel = headerViewModel
        self.carouselViewModel = carouselViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        carouselViewModel.fetch()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.MainColors.primaryBackground
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        view.addSubview(scrollView)
        scrollView.anchor(top: headerView.bottomAnchor, topConstant: 0,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        
        scrollView.addSubview(contentView)
        contentView.fillSuperview()
        contentView.setDimensions(width: scrollView.frame.width, height: scrollView.frame.height)
        contentView.centerInSuperview()
        
        contentView.addSubview(introductionView)
        introductionView.anchor(top: contentView.topAnchor, topConstant: -20,
                                leading: contentView.leadingAnchor, leadingConstant: 0,
                                trailing: contentView.trailingAnchor, trailingConstant: 0)
        introductionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        contentView.addSubview(feedInfoWrapperView)
        feedInfoWrapperView.anchor(top: introductionView.bottomAnchor, topConstant: -30)
        feedInfoWrapperView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        feedInfoWrapperView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        
        
        contentView.addSubview(countryCarouselView)
        countryCarouselView.anchor(top: feedInfoWrapperView.bottomAnchor, topConstant: 40,
                                       leading: contentView.leadingAnchor,
                                       trailing: contentView.trailingAnchor)
        countryCarouselView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        contentView.addSubview(categoriesTitleLabel)
        categoriesTitleLabel.anchor(top: countryCarouselView.bottomAnchor, topConstant: 40,
                                    leading: contentView.leadingAnchor, leadingConstant: 10,
                                    trailing: contentView.trailingAnchor, trailingConstant: 10)
        
        contentView.addSubview(categoryCollectionView)
        categoryCollectionView.anchor(top: categoriesTitleLabel.bottomAnchor, topConstant: 10,
                                      leading: contentView.leadingAnchor,
                                      trailing: contentView.trailingAnchor)
        categoryCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.bringSubviewToFront(headerView)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func navigateToHotNews(country: String? = nil, category: String? = nil) {
        guard let tabController = tabBarController as? TabBarController else { return }
        if let country = country {
            tabController.hotNewsViewModel.searchForCountry(country)
        }
        if let category = category {
            tabController.hotNewsViewModel.searchForCategory(category)
        }
        tabController.selectedIndex = tabController.hotNewsViewModel.tabBarIndex
    }
    
    @objc private func navigateToFeed() {
        let vc = FeedViewController(viewModel: FeedViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}

extension HomeViewController: CarouselViewDelegate {
    func didTapOnCarouselCell(with value: String) {
        navigateToHotNews(country: value)
    }
    
    func didUpdate() {
        refreshControl.endRefreshing()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToHotNews(category: categories[indexPath.row].getModel().value)
    }
}

// MARK: - UIRefreshControl

extension HomeViewController {
    @objc func userDidRefresh(refreshControl: UIRefreshControl) {
        carouselViewModel.fetch()
    }
}
