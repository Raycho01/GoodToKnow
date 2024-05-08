//
//  DarkModeView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 8.05.24.
//

import UIKit

final class DarkModeView: UIView {
    
    private let userDefaultsManager = UserDefaultsManager.shared
    
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
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = Strings.Settings.darkMode
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(hStack)
        hStack.fillSuperview()
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(spacerView)
        hStack.addArrangedSubview(switchButton)
    }
    
    @objc private func didTapSwitchButton() {
        if switchButton.isOn {
            self.window?.overrideUserInterfaceStyle = .dark
            userDefaultsManager.saveInterfaceStyle(.dark)
        } else {
            self.window?.overrideUserInterfaceStyle = .light
            userDefaultsManager.saveInterfaceStyle(.light)
        }
    }
}
