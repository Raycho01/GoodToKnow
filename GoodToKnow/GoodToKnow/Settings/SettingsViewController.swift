//
//  SettingsViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 31.03.24.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let headerViewModel = NewsListHeaderViewModel(title: "Settings", shouldShowSearch: false)
    private let userDefaultsManager = UserDefaultsManager.shared
    
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
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.layer.cornerRadius = 5
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var switchLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark mode"
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor.MainColors.primaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.addTarget(self, action: #selector(didTapSwitchButton), for: .touchUpInside)
        button.isOn = userDefaultsManager.retrieveInterfaceStyle() == .dark ? true : false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
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
        vStack.addArrangedSubview(hStack)
        hStack.addArrangedSubview(switchLabel)
        hStack.addArrangedSubview(spacerView)
        hStack.addArrangedSubview(switchButton)
        vStack.addSeparatorView()
    }
    
    @objc private func didTapSwitchButton() {
        if switchButton.isOn {
            view.window?.overrideUserInterfaceStyle = .dark
            userDefaultsManager.saveInterfaceStyle(.dark)
        } else {
            view.window?.overrideUserInterfaceStyle = .light
            userDefaultsManager.saveInterfaceStyle(.light)
        }
    }
}

extension SettingsViewController: NewsListHeaderDelegate {
    func didSearch(for keyword: String) {}
}
