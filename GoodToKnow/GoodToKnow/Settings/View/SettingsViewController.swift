//
//  SettingsViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 31.03.24.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let headerViewModel = NewsListHeaderViewModel(title: Strings.ScreenTitles.settings, shouldShowSearch: false)
    
    private lazy var headerView: NewsListHeaderView = {
        let headerView = NewsListHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 8),
                           viewModel: headerViewModel)
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.MainColors.primaryBackground
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.MainColors.veryLightBackground
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var darkModeView: DarkModeView = {
        DarkModeView()
    }()
    
    private lazy var languageView: LanguageView = {
        return LanguageView(frame: .zero, navigationController: navigationController!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        contentView.centerInSuperview()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true

        contentView.addSubview(vStack)
        vStack.anchor(top: contentView.topAnchor, topConstant: 20,
                      leading: contentView.leadingAnchor, leadingConstant: 20,
                      trailing: contentView.trailingAnchor, trailingConstant: 20)
        
        vStack.addSeparatorView()
        vStack.addArrangedSubview(darkModeView)
        vStack.addSeparatorView()
        vStack.addArrangedSubview(languageView)
        vStack.addSeparatorView()
    }
}

extension SettingsViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}
