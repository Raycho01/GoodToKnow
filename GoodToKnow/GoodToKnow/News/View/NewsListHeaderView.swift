//
//  HotNewsHeaderView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation
import UIKit

struct NewsListHeaderViewModel {
    var title: String
    var shouldShowSearch: Bool
}

protocol NewsListHeaderDelegate: AnyObject {
    func didSearch(for keyword: String)
}

final class NewsListHeaderView: UIView {
    
    enum State {
        case normal, searching
    }
    
    private let viewModel: NewsListHeaderViewModel
    private var state: NewsListHeaderView.State = .normal {
        didSet {
            stateDidChange(to: state)
        }
    }
    weak var delegate: NewsListHeaderDelegate?
    
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
    
    private lazy var redDotImageView: UIImageView = {
        let redDotImage = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 8))
        let redDotImageView = UIImageView(image: redDotImage)
        redDotImageView.tintColor = .red
        redDotImageView.contentMode = .scaleAspectFit
        redDotImageView.isHidden = true
        redDotImageView.translatesAutoresizingMaskIntoConstraints = false
        return redDotImageView
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

    init(frame: CGRect, viewModel: NewsListHeaderViewModel) {
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
        
        searchButton.addSubview(redDotImageView)
        redDotImageView.anchor(top: searchButton.topAnchor,
                               trailing: searchButton.trailingAnchor)
    }
    
    @objc private func didTapSearch() {
        switch state {
        case .normal:
            state = .searching
        case .searching:
            search()
            state = .normal
        }
    }
    
    private func search() {
        guard let searchKeyword = searchTextField.text,
              searchKeyword.trimmingCharacters(in: .whitespacesAndNewlines) != lastSearchedKeyword.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        lastSearchedKeyword = searchKeyword
        showRedDotIfSearching()
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
            searchTextField.resignFirstResponder()
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
    
    private func showRedDotIfSearching() {
        redDotImageView.isHidden = lastSearchedKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

// MARK: UITextFieldDelegate

extension NewsListHeaderView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            return true
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        state = .normal
        search()
        textField.resignFirstResponder()
        return true
    }
}
