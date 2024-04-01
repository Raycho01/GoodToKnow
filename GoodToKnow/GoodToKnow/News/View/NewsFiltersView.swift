//
//  NewsFiltersView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.03.24.
//

import UIKit

protocol NewsFiltersViewDelegate: AnyObject {
    func didTapClearAll()
}

final class NewsFiltersView: UIView {
    
    private var filters: NewsSearchFilters {
        didSet {
            setupStackView()
        }
    }
    
    private let initialFrame: CGRect
    
    weak var delegate: NewsFiltersViewDelegate?
    
    private lazy var clearAllButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "trash")
        config.imagePlacement = .leading
        
        let button = UIButton(configuration: config)
        button.tintColor = UIColor.red.withAlphaComponent(0.4)
        button.addTarget(self, action: #selector(didTapClearAll), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    init(frame: CGRect, filters: NewsSearchFilters) {
        self.filters = filters
        self.initialFrame = frame
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func udpateFilters(_ filters: NewsSearchFilters) {
        self.filters = filters
    }
    
    private func setupUI() {
        addSubview(clearAllButton)
        clearAllButton.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 10)
        clearAllButton.setDimensions(width: 30, height: 30)
        
        addSubview(hStack)
        hStack.anchor(top: topAnchor, bottom: bottomAnchor, leading: clearAllButton.trailingAnchor, leadingConstant: 5)
        
        addSubview(spacerView)
        spacerView.anchor(top: topAnchor, bottom: bottomAnchor, leading: hStack.trailingAnchor, leadingConstant: 5, trailing: trailingAnchor)
    }
    
    private func setupStackView() {
        hStack.removeAllSubviews()
        
        if filters.country != "us", !filters.country.isEmpty { // workaround, beacuse of the API
            let countryLabel = createLabel(with: filters.country)
            hStack.addArrangedSubview(countryLabel)
        }
        
        if filters.keyword != "a", !filters.keyword.isEmpty { // workaround, beacuse of the API
            let keywordLabel = createLabel(with: filters.keyword)
            hStack.addArrangedSubview(keywordLabel)
        }
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = PaddingLabel()
        label.textColor = UIColor.MainColors.accentColor
        label.backgroundColor = UIColor.MainColors.accentColor?.withAlphaComponent(0.2)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.text = text
        label.layer.masksToBounds = true
        return label
    }
    
    @objc private func didTapClearAll() {
        delegate?.didTapClearAll()
    }
}
