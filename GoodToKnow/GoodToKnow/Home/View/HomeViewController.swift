//
//  HomeViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 18.03.24.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Browse news by categories"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Countries"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 150) // Adjust the size as needed
        layout.minimumInteritemSpacing = 10 // Adjust spacing between cells
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Adjust section insets

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "HomeCell")

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(contentView)
        contentView.fillSuperview()
        contentView.setDimensions(width: scrollView.frame.width, height: scrollView.frame.height)
        contentView.centerInSuperview()
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor, topConstant: 20)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(countriesLabel)
        countriesLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 20,
                              leading: contentView.leadingAnchor, leadingConstant: 20,
                              trailing: contentView.trailingAnchor, trailingConstant: 10)
        
        contentView.addSubview(countriesCollectionView)
        countriesCollectionView.anchor(top: countriesLabel.bottomAnchor, topConstant: 5,
                                       leading: contentView.leadingAnchor, leadingConstant: 10,
                                       trailing: contentView.trailingAnchor, trailingConstant: 10)
        countriesCollectionView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
