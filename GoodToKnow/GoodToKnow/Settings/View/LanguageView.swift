//
//  LanguageView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 8.05.24.
//

import UIKit

final class LanguageView: UIView {

    private let navigationController: UINavigationController
    
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
        label.text = Strings.Settings.language
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor.MainColors.primaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var dropDownButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = createDropDownMenu()
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = UIColor.MainColors.secondaryText
        button.titleLabel?.font = .systemFont(ofSize: 18)
        return button
    }()
    
    private func createDropDownMenu() -> UIMenu {
        var dropDownElements: [UIMenuElement] = []
        for language in AppLanguages.languages {
            dropDownElements.append(UIAction(title: language.display, handler: dropDownTapAction))
        }
        return UIMenu(options: .displayInline, children: dropDownElements)
    }
    
    private lazy var dropDownTapAction = { (action: UIAction) in
        guard action.title != AppLanguages.languages.first?.display else { return }
        
        let alertVC = UIAlertController(title: Strings.Alert.restartTitle, message: Strings.Alert.restartSubtitle, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: Strings.Alert.continueActionTitle, style: .destructive, handler: { _ in
            AppLanguages.swapLanguages()
            exit(-1)
        }))
        alertVC.addAction(UIAlertAction(title: Strings.Alert.cancelActionTitle, style: .cancel, handler: { _ in
            self.dropDownButton.menu = self.createDropDownMenu()
        }))
        
        self.navigationController.present(alertVC, animated: true)
    }
    
    init(frame: CGRect, navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        hStack.addArrangedSubview(dropDownButton)
    }
}
