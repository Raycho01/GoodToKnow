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
    
    enum State {
        case normal, searching
    }
    
    private let viewModel: NewsListHeaderViewModelProtocol
    private var state: NewsListHeaderView.State = .normal {
        didSet {
            stateDidChange(to: state)
        }
    }
    weak var delegate: NewsListHeaderDelegate?
    
    private var isSearchTextFieldHidden = true {
        didSet {
            searchTextField.isHidden = isSearchTextFieldHidden
            if isSearchTextFieldHidden {
                mainStackView.removeArrangedSubview(searchTextField)
            } else {
                mainStackView.insertArrangedSubview(searchTextField, at: 0)
            }
        }
    }
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
        switch state {
        case .normal:
            state = .searching
        case .searching:
            search()
        }
    }
    
    private func search() {
        guard let searchKeyword = searchTextField.text, searchKeyword != lastSearchedKeyword else { return }
        lastSearchedKeyword = searchKeyword
        delegate?.didSearch(for: searchKeyword)
    }
    
    @objc private func timerFired() {
        search()
    }
    
    private func refreshSearchTextField() {
        searchTextField.text = searchTextField.text
    }
    
    private func stateDidChange(to state: NewsListHeaderView.State) {
        switch state {
        case .normal:
            setupNormalState()
        case .searching:
            setupSearchingState()
        }
    }
    
    private func setupNormalState() {
        hideSearchTextField(true)
        hideHeaderTitleLabel(false)
    }
    
    private func setupSearchingState() {
        hideHeaderTitleLabel(true)
        hideSearchTextField(false)
    }
    
    private func hideSearchTextField(_ isHidden: Bool) {
        searchTextField.isHidden = isHidden
        if isHidden {
            mainStackView.removeArrangedSubview(searchTextField)
        } else {
            mainStackView.insertArrangedSubview(searchTextField, at: 0)
            refreshSearchTextField()
            searchTextField.becomeFirstResponder()
        }
    }
    
    private func hideHeaderTitleLabel(_ isHidden: Bool) {
        headerTitleLabel.isHidden = isHidden
        if isHidden {
            mainStackView.removeArrangedSubview(headerTitleLabel)
        } else {
            mainStackView.insertArrangedSubview(headerTitleLabel, at: 0)
        }
    }
    
}

// MARK: UITextFieldDelegate

extension NewsListHeaderView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            return true
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField.text == "" {
            state = .normal
        }
        search()
        textField.resignFirstResponder()
        return true
    }
}