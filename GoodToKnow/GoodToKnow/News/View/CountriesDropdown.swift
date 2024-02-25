//
//  CountriesDropdown.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 24.01.24.
//

import Foundation
import UIKit

class CountriesDropdown: UIView {
    
    // MARK: - UI Elements
    private let flagButton = UIButton()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var isDropdownOpen = false
    
    // MARK: - Array of country codes
    private let countries: [String] = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn",
                                       "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu",
                                       "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma",
                                       "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro",
                                       "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw",
                                       "ua", "us", "ve", "za"]
    private let defaultCountry = "bg"
    
    var didSelectCountry: ((String) -> Void)?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        setupFlagButton()
        setupScrollView()
        setupStackView()
    }
    
    private func setupFlagButton() {
        flagButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flagButton)
        flagButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flagButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        flagButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        flagButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        flagButton.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        
        flagButton.layoutIfNeeded()
        flagButton.layer.cornerRadius = flagButton.frame.height / 2
        flagButton.clipsToBounds = true
        
        setFlagImage(for: defaultCountry)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: flagButton.bottomAnchor, constant: 10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.isHidden = true // Initially hidden
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        // Add country buttons to the stack
        for country in countries {
            let countryButton = UIButton()
            countryButton.translatesAutoresizingMaskIntoConstraints = false
            countryButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            countryButton.setImage(UIImage.getFlagOf(country: country), for: .normal)
            countryButton.addTarget(self, action: #selector(countrySelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(countryButton)
            
            // Force layout of the button to calculate its frame
            countryButton.layoutIfNeeded()
            countryButton.layer.cornerRadius = countryButton.frame.height / 2
            countryButton.clipsToBounds = true
        }
    }
    
    @objc private func flagButtonTapped() {
        isDropdownOpen.toggle()
        scrollView.isHidden = !isDropdownOpen
    }
    
    @objc private func countrySelected(_ sender: UIButton) {
        guard let countryCode = sender.title(for: .normal)?.lowercased() else { return }
        setFlagImage(for: countryCode)
        flagButtonTapped()
        didSelectCountry?(countryCode)
    }
    
    private func setFlagImage(for countryCode: String) {
//        flagButton.setImage(UIImage.getFlagOf(country: countryCode), for: .normal)
    }
}
