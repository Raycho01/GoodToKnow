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
        label.textColor = UIColor.MainColors.primaryText
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        backgroundColor = UIColor.MainColors.accentColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 40
    }
    
    private func setupConstraints() {
        addSubview(headerTitleLabel)
        headerTitleLabel.centerInSuperview()
    }
}
