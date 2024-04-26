//
//  HomeViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 18.03.24.
//

import UIKit
import Combine

protocol HomeCarouselViewModelProtocol {
    func bind() -> AnyPublisher<[HomeCarouselModel], Never>
}

final class HomeViewController: UIViewController {
    
    private let headerViewModel: NewsListHeaderViewModel
    private let carouselViewModel: HomeCarouselViewModelProtocol
    
    private var filters = NewsSearchFilters()
    
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
    
    private lazy var countryCarouselView: HomeCarouselView = {
        let carouselView = HomeCarouselView(viewModel: carouselViewModel, frame: CGRect(x: 0, y: 0,
                                                                                     width: view.frame.width,
                                                                                     height: 100))
        carouselView.delegate = self
        return carouselView
    }()
    
    private lazy var wideRectListView: WideRectListView = {
        let view = WideRectListView(items: [WideRectListViewModel(icon: "eraser", value: "School")])
        return view
    }()
    
    init(carouselViewModel: HomeCarouselViewModelProtocol = HomeCarouselViewModel(), headerViewModel: NewsListHeaderViewModel) {
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
        
        contentView.addSubview(wideRectListView)
        wideRectListView.anchor(top: countryCarouselView.bottomAnchor, topConstant: 20, leading: contentView.leadingAnchor,
                                trailing: contentView.trailingAnchor)
        wideRectListView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func navigateToHotNews(with filters: NewsSearchFilters) {
        guard let tabController = tabBarController as? TabBarController else { return }
        tabController.hotNewsViewModel.searchFilters = filters
        tabController.selectedIndex = tabController.hotNewsViewModel.tabBarIndex
    }
}

extension HomeViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}

extension HomeViewController: HomeCarouselViewDelegate {
    func didTapOnCarouselCell(with value: String) {
        filters.country = value
        navigateToHotNews(with: filters)
    }
}
