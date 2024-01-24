//
//  HotNewsHeaderView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation
import UIKit

final class HotNewsHeaderView: UIView {
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hot News"
        label.textColor = UIColor.MainColors.textPrimary
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dropDown: CountriesDropdown = {
        let dropDown = CountriesDropdown()
        dropDown.didSelectCountry = { [weak self] country in
            self?.delegate?.didChangeCountry(to: country)
        }
        return dropDown
    }()
    
    var delegate: HotNewsHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDimensions(width: frame.width, height: frame.height)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.MainColors.backgroundSecondary
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 40
    }
    
    private func setupConstraints() {
        addSubview(headerTitleLabel)
        headerTitleLabel.centerInSuperview()
        
        addSubview(dropDown)
        dropDown.anchorToSuperview(top: topAnchor, topConstant: 60, bottom: bottomAnchor, bottomConstant: 15, leading: leadingAnchor, leadingConstant: 10)
        dropDown.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

protocol HotNewsHeaderDelegate {
    
    func didChangeCountry(to country: String)
}
