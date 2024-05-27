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
        cardSwiperView.visibleNextCardHeight = 20
        cardSwiperView.isSideSwipingEnabled = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
    }
    
    private func bindViewModel() {
        viewModel.fetchNewsInitially()
        viewModel.newsArticlesDidUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.cardSwiperView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(with: error)
            }
        }
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
    
    private func loadMoreNewsIfNeeded(index: Int) {
        if index == viewModel.newsArticles.count - 2 {
            viewModel.fetchMoreNews()
        }
    }
    
}

// MARK: Delegates
extension FeedViewController: VerticalCardSwiperDatasource {
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        loadMoreNewsIfNeeded(index: index)
        
        guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: index) as? FeedCell else {
            return CardCell()
        }

        cell.configure(with: viewModel.newsArticles[index])
        return cell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return viewModel.newsArticles.count
    }
}

extension FeedViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}
