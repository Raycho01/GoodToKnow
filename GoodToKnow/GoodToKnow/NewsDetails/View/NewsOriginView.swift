//
//  NewsOriginView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 17.03.24.
//

import UIKit

final class NewsOriginView: UIView {
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let author: String
    private let source: String
    private let publishedAt: String
    
    init(frame: CGRect, author: String, source: String, publishedAt: String) {
        self.author = author
        self.source = source
        self.publishedAt = publishedAt
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.veryLightBackground
        layer.cornerRadius = self.frame.height / 8
        setShadow()
        addSubview(vStackView)
        vStackView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        addRow(icon: "person.fill", firstText: "Author:", secondText: author, separator: true)
        addRow(icon: "link.circle", firstText: "Source:", secondText: source, separator: true)
        addRow(icon: "calendar", firstText: "Published at:", secondText: publishedAt)
    }
    
    private func addRow(icon: String, firstText: String, secondText: String, separator: Bool = false) {
        let rowView = UIStackView()
        rowView.axis = .horizontal
        rowView.spacing = 10
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.MainColors.primaryText
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rowView.addArrangedSubview(iconImageView)
        
        let firstLabel = UILabel()
        firstLabel.text = firstText
        firstLabel.textColor = UIColor.MainColors.primaryText
        firstLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rowView.addArrangedSubview(firstLabel)
        
        let secondLabel = UILabel()
        secondLabel.text = secondText
        secondLabel.textColor = UIColor.MainColors.secondaryText
        secondLabel.font = .systemFont(ofSize: 14)
        secondLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rowView.addArrangedSubview(secondLabel)
        
        vStackView.addArrangedSubview(rowView)
        
        guard separator else { return }
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .black.withAlphaComponent(0.1)
        vStackView.addArrangedSubview(separator)
        separator.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.98).isActive = true
    }
}
