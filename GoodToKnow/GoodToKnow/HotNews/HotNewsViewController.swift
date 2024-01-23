//
//  ViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import UIKit

class HotNewsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = createTableHeader()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    // MARK: Configuration
    
    private func createTableHeader() -> HotNewsHeaderView {
        HotNewsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4))
    }
    
    private func setupConstraints() {
        view.addSubview(newsTableView)
        newsTableView.setDimensions(width: view.frame.width, height: view.frame.height)
        newsTableView.fillSuperview()
    }

}

// MARK: - UITableView delegate and data source

extension HotNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        cell.backgroundColor = .blue
        return cell
    }
}
