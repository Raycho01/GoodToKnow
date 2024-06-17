//
//  ReadLaterViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 17.06.24.
//

import Foundation
import UIKit

protocol ReadLaterViewModelProtocol {
    
    var newsArticles: [NewsArticle] { get }
    var isCurrenltyLoading: ((Bool) -> Void) { get set }
    var newsDidUpdate : (() -> Void) { get set }
    
    func fetchNews()
    func removeArticle(at index: Int)
}

final class ReadLaterViewController: UIViewController {
    
    private let insetValue: CGFloat = 15
    private var viewModel: ReadLaterViewModelProtocol
    
    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.identifier)
        tableView.backgroundColor = UIColor.MainColors.veryLightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 20
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: ReadLaterViewModelProtocol) {
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
        viewModel.fetchNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    private func bindViewModel() {
        viewModel.newsDidUpdate = { [weak self] in
            self?.newsTableView.reloadData()
        }
        
        viewModel.isCurrenltyLoading = { [weak self] isCurrenltyLoading in
            self?.handleLoading(isLoading: isCurrenltyLoading)
        }
    }
    
    private func handleLoading(isLoading: Bool) {
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    private func setupUI() {
        setupNavigation()
        view.backgroundColor = UIColor.MainColors.headerBackground
        
        view.addSubview(newsTableView)
        
        newsTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 20,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20,
                             leading: view.leadingAnchor, leadingConstant: 10,
                             trailing: view.trailingAnchor, trailingConstant: 10)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    private func setupNavigation() {
        title = Strings.ScreenTitles.readLater
        navigationController?.navigationBar.tintColor = UIColor.primaryText
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}

// MARK: - UITableView delegate and data source

extension ReadLaterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier, for: indexPath) as? NewsListTableViewCell else {
            return UITableViewCell()
        }
        let article = viewModel.newsArticles[indexPath.row]
        cell.configure(with: article, showSkeleton: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.newsArticles[indexPath.row]
        let viewController = NewsDetailsViewController(newsArticle: article)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeArticle(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
