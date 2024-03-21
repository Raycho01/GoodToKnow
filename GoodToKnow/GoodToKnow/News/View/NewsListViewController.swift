//
//  ViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import UIKit

class NewsListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var newsArticles: [NewsArticle] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.newsTableView.reloadData()
            }
        }
    }
    
    private var viewModel: NewsListViewModelProtocol
    private let insetValue: CGFloat = 15
    
    // MARK: - UI Elements
    
    private lazy var headerView: NewsListHeaderView = {
        let headerView = NewsListHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 8),
                                            viewModel: viewModel.headerModel)
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.identifier)
        tableView.backgroundColor = UIColor.MainColors.primaryBackground
        tableView.contentInset = UIEdgeInsets(top: insetValue, left: 0, bottom: insetValue, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        viewModel.fetchNewsInitially()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        setupConstraints()
    }
    
    private func bindViewModel() {
        viewModel.newsResponseDidUpdate = { [weak self] newsResponse in
            guard let newsResponse = newsResponse else { return }
            self?.updateData(with: newsResponse)
        }
        
        viewModel.onError = { [weak self] error in
            self?.showAlert(with: error)
        }
    }
    
    private func updateData(with newsResponse: NewsResponse) {
        newsArticles = newsResponse.articles
    }
    
    private func setupConstraints() {
        view.addSubview(newsTableView)
        view.addSubview(headerView)
        
        headerView.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        newsTableView.anchor(top: headerView.bottomAnchor,
                             topConstant: -insetValue,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             bottomConstant: -insetValue,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.MainColors.primaryBackground
        newsTableView.contentOffset = CGPoint(x: 0, y: -insetValue)
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
}

// MARK: - UITableView delegate and data source

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier, for: indexPath) as? NewsListTableViewCell else {
            return UITableViewCell()
        }
        let article = newsArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = newsArticles[indexPath.row]
        let viewController = NewsDetailsViewController(newsArticle: article)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Delegates

extension NewsListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (newsTableView.contentSize.height - 100 - scrollView.frame.size.height) { // Reached the bottom of the table view
            
            guard !viewModel.isCurrentlyFetching else { return }
            viewModel.fetchMoreNews()
        }
    }
}

extension NewsListViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {
        viewModel.searchFilters.keyword = keyword
    }
}
