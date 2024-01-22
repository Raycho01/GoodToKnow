//
//  ViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import UIKit

class HotNewsViewController: UIViewController {
    
    // MARK: - UI Elements

    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 60
        return view
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hot News"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    private func setupUI() {
        
    }
    
    private func setupConstraints() {
        
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.fillSuperview()
        
        view.addSubview(headerView)
        headerView.setDimensions(width: view.frame.width, height: view.frame.height / 4)
        headerView.anchorToSuperview(top: headerView.topAnchor, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor)
    }

}
