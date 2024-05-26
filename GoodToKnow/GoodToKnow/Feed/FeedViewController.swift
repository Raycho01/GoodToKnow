//
//  FeedViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.05.24.
//

import Foundation
import UIKit
import VerticalCardSwiper

final class FeedViewController: UIViewController {
    
    private var viewModel: FeedViewModelProtocol
    
    private lazy var cardSwiperView: VerticalCardSwiper = {
        let cardSwiperView = VerticalCardSwiper(frame: self.view.bounds)
        cardSwiperView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        cardSwiperView.datasource = self
        cardSwiperView.isStackingEnabled = false
        cardSwiperView.visibleNextCardHeight = 0
        return cardSwiperView
    }()
    
    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(cardSwiperView)
        cardSwiperView.anchor(top: view.topAnchor, topConstant: 20, bottom: view.bottomAnchor, bottomConstant: 20, leading: view.leadingAnchor, leadingConstant: 5, trailing: view.trailingAnchor, trailingConstant: 5)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationItem.hidesBackButton = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor.MainColors.primaryText
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.fetchNewsInitially()
        viewModel.newsArticlesDidUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.cardSwiperView.reloadData()
            }
        }
    }
    
}

extension FeedViewController: VerticalCardSwiperDatasource {
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: index) as? FeedCell {
            cell.configure(with: viewModel.newsArticles[index], isLoading: viewModel.isCurrenltyLoading)
            return cell
        }
        return CardCell()
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return viewModel.newsArticles.count
    }
}

extension FeedViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}
