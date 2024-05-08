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
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.text = Strings.SectionTitles.categories
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

        return collectionView
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
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.MainColors.primaryBackground
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        view.addSubview(scrollView)
        scrollView.anchor(top: headerView.bottomAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        
        scrollView.addSubview(contentView)
        contentView.fillSuperview()
        contentView.setDimensions(width: scrollView.frame.width, height: scrollView.frame.height)
        contentView.centerInSuperview()
        
        contentView.addSubview(countryCarouselView)
        countryCarouselView.anchor(top: contentView.topAnchor, topConstant: 40,
                                       leading: contentView.leadingAnchor,
                                       trailing: contentView.trailingAnchor)
        countryCarouselView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        contentView.addSubview(categoriesTitleLabel)
        categoriesTitleLabel.anchor(top: countryCarouselView.bottomAnchor, topConstant: 40,
                                    leading: contentView.leadingAnchor, leadingConstant: 10,
                                    trailing: contentView.trailingAnchor, trailingConstant: 10)
        
        contentView.addSubview(categoryCollectionView)
        categoryCollectionView.anchor(top: categoriesTitleLabel.bottomAnchor, topConstant: 10,
                                      bottom: contentView.bottomAnchor, bottomConstant: 20,
                                      leading: contentView.leadingAnchor, leadingConstant: 10,
                                      trailing: contentView.trailingAnchor, trailingConstant: 10)
        
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func navigateToHotNews() {
        guard let tabController = tabBarController as? TabBarController else { return }
        tabController.selectedIndex = tabController.hotNewsViewModel.tabBarIndex
    }
}

extension HomeViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}

extension HomeViewController: CarouselViewDelegate {
    func didTapOnCarouselCell(with value: String) {
        GlobalSearchFilters.shared.searchFilters.country = value
        navigateToHotNews()
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
        GlobalSearchFilters.shared.searchFilters.category = categories[indexPath.row].getModel().value
        navigateToHotNews()
    }
}
