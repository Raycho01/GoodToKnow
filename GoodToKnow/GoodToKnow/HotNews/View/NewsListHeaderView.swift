//
//  HotNewsHeaderView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation
import UIKit

protocol NewsListHeaderViewModelProtocol {
    var title: String { get }
    var shouldShowSearch: Bool { get }
}

protocol NewsListHeaderDelegate: AnyObject {
    func didSearch(for keyword: String)
}

final class NewsListHeaderView: UIView {
    
    private let viewModel: NewsListHeaderViewModelProtocol
    weak var delegate: NewsListHeaderDelegate?
    private var isSearchTextFieldAdded = false
    private var timer: Timer?
    private var lastSearchedKeyword = ""
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.textColor = UIColor.MainColors.primaryText
        label.font = .getCopperplateFont(size: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray4
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.searchIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        button.tintColor = UIColor.MainColors.primaryText
        button.setDimensions(width: 30, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(frame: CGRect, viewModel: NewsListHeaderViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.setDimensions(width: frame.width, height: frame.height)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.MainColors.tabBarBackground
        translatesAutoresizingMaskIntoConstraints = false
        self.roundCorners()
    }
    
    private func setupConstraints() {
        addSubview(mainStackView)
        mainStackView.fillSuperview(padding: UIEdgeInsets(top: 50, left: 20, bottom: 10, right: 20))
        mainStackView.addArrangedSubview(headerTitleLabel)
        if viewModel.shouldShowSearch {
            mainStackView.addArrangedSubview(searchButton)
        }
    }
    
    @objc private func didTapSearch() {
        if !isSearchTextFieldAdded {
            addSearchTextField()
        } else {
            callDelegate()
        }
    }
    
    private func addSearchTextField() {
        refreshSearchTextField()
        searchTextField.isHidden = false
        mainStackView.insertArrangedSubview(searchTextField, at: 1)
        searchTextField.becomeFirstResponder()
        isSearchTextFieldAdded = true
    }
    
    private func callDelegate() {
        guard let searchKeyword = searchTextField.text, searchKeyword != lastSearchedKeyword else { return }
        lastSearchedKeyword = searchKeyword
        delegate?.didSearch(for: searchKeyword)
    }
    
    @objc private func timerFired() {
        callDelegate()
    }
    
    private func removeSearchTextFieldIfEmpty() {
        guard searchTextField.text == "" else { return }
        
        searchTextField.isHidden = true
        mainStackView.removeArrangedSubview(searchTextField)
        isSearchTextFieldAdded = false
    }
    
    private func refreshSearchTextField() {
        searchTextField.text = searchTextField.text
    }
    
}

// MARK: UITextFieldDelegate

extension NewsListHeaderView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            return true
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        removeSearchTextFieldIfEmpty()
        callDelegate()
        textField.resignFirstResponder()
        return true
    }
}
