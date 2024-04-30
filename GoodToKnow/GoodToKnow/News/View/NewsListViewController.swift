//
//  ViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import UIKit
import SkeletonView

class NewsListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var newsArticles: [NewsArticle] = [] {
        didSet {
            showEmptyViewIfNeeded()
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
    
    private var isCurrentlyLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isCurrentlyLoading, !self.refreshControl.isRefreshing, !self.newsTableView.sk.isSkeletonActive {
                    self.activityIndicatorView.startAnimating()
                } else {
                    self.activityIndicatorView.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
                self.newsTableView.reloadData()
            }
        }
    }
    
    private var filtersObserver: SearchFiltersObserver?
    
    private var viewModel: NewsListViewModelProtocol
    private let insetValue: CGFloat = 15
    private var filterViewHeightConstraint: NSLayoutConstraint = .init()
    private var filterViewHeight: CGFloat = 40
    
    // MARK: - UI Elements
    
    private lazy var headerView: NewsListHeaderView = {
        let headerView = NewsListHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 8),
                                            viewModel: viewModel.headerModel)
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var filterView: NewsFiltersView = {
        let view = NewsFiltersView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: filterViewHeightConstraint.constant))
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: insetValue, left: 0, bottom: insetValue, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(userDidRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Configuration
    
    init(viewModel: NewsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        viewModel.fetchNewsInitially()
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bindViewModel() {
        viewModel.newsResponseDidUpdate = { [weak self] newsResponse in
            guard let newsResponse = newsResponse else { return }
            self?.newsArticles = newsResponse.articles
        }
        
        viewModel.onError = { [weak self] error in
            self?.newsArticles = []
            self?.showAlert(with: error)
        }
        
        viewModel.isCurrenltyLoading = { [weak self] isCurrenltyLoading in
            self?.isCurrentlyLoading = isCurrenltyLoading
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.MainColors.primaryBackground
        newsTableView.contentOffset = CGPoint(x: 0, y: -insetValue)
        
        view.addSubview(newsTableView)
        view.addSubview(headerView)
        
        headerView.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        
        view.addSubview(filterView)
        filterView.anchor(top: headerView.bottomAnchor, topConstant: 5,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        filterViewHeightConstraint = NSLayoutConstraint(item: filterView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 0, constant: 0)
        filterViewHeightConstraint.isActive = true
        
        newsTableView.anchor(top: filterView.bottomAnchor, topConstant: 5,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             bottomConstant: -insetValue,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    private func showAlert(with error: Error) {
        let retryAction = AlertPopupAction(title: "Retry", isPreferred: true, action: { [weak self] in
            self?.viewModel.fetchNewsInitially()
        })
        let cancelAction = AlertPopupAction(title: "Cancel", isPreferred: false, action: { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        })
        let title = NSAttributedString(string: "Oops, something went wrong.")
        let message = NSAttributedString(string: error.localizedDescription, attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .light)
        ])
        
        showAlertPopup(title: title, message: message, preferredStyle: .alert, actions: [retryAction, cancelAction])
    }
    
    private func showEmptyViewIfNeeded() {
        showEmptyState(newsArticles.count < 1, with: UIAction(handler: { _ in
            self.showEmptyState(false, with: nil)
            self.viewModel.fetchNewsInitially()
        }))
    }
    
    private func updateFilterViewAppearance(with filters: NewsSearchFilters) {
        if filters.country.isEmpty && filters.keyword.isEmpty && filters.category.isEmpty {
            filterView.isHidden = true
            filterViewHeightConstraint.constant = 0
        } else {
            filterView.isHidden = false
            filterViewHeightConstraint.constant = filterViewHeight
        }
    }
    
    private func setupObserver() {
        filtersObserver = SearchFiltersObserver(filtersDidUpdate: { [weak self] filters in
            self?.updateFilterViewAppearance(with: filters)
        })
    }
}

// MARK: - UITableView delegate and data source

extension NewsListViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier, for: indexPath) as? NewsListTableViewCell else {
            return UITableViewCell()
        }
        let article = newsArticles[indexPath.row]
        cell.configure(with: article, showSkeleton: isCurrentlyLoading)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = newsArticles[indexPath.row]
        let viewController = NewsDetailsViewController(newsArticle: article)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewsListTableViewCell.identifier
    }
}

// MARK: - Delegates

extension NewsListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (newsTableView.contentSize.height - 100 - scrollView.frame.size.height) { // Reached the bottom of the table view
            
            guard !isCurrentlyLoading else { return }
            viewModel.fetchMoreNews()
        }
    }
}

extension NewsListViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {
        GlobalSearchFilters.shared.searchFilters.keyword = keyword
    }
}

extension NewsListViewController: NewsFiltersViewDelegate {
    func didTapClearAll() {
        GlobalSearchFilters.shared.searchFilters = NewsSearchFilters()
        headerView.clearSearch()
    }
}

// MARK: - UIRefreshControl

extension NewsListViewController {
    @objc func userDidRefresh(refreshControl: UIRefreshControl) {
        viewModel.fetchNewsInitially()
    }
}
