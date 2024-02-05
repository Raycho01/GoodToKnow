//
//  ViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import UIKit

class HotNewsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HotNewsViewModel
    private let insetValue: CGFloat = 15
    
    // MARK: - UI Elements
    
    private lazy var headerView: HotNewsHeaderView = {
        HotNewsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 8))
    }()
    
    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(HotNewsTableViewCell.self, forCellReuseIdentifier: "HotNewsTableViewCell")
        tableView.backgroundColor = UIColor.MainColors.primaryBackground
        tableView.contentInset = UIEdgeInsets(top: insetValue, left: 0, bottom: insetValue, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    // MARK: Configuration
    
    init(viewModel: HotNewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        setupConstraints()
    }
    
    private func setupViewModel() {
        viewModel.newsResponseDidUpdate = { [weak self] in
            self?.updateData()
        }
    }
    
    private func updateData() {
        DispatchQueue.main.async { [weak self] in
            self?.newsTableView.reloadData()
        }
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

}

// MARK: - UITableView delegate and data source

extension HotNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsResponse?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotNewsTableViewCell.identifier, for: indexPath) as! HotNewsTableViewCell
        guard let article = viewModel.newsResponse?.articles[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: article)
        return cell
    }
}

// MARK: - ScrollView delegate

extension HotNewsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (newsTableView.contentSize.height - 100 - scrollView.frame.size.height) { // Reached the bottom of the table view
            
            guard !viewModel.isCurrentlyFetching else { return }
            viewModel.fetchMoreHotNews()
        }
    }
}
