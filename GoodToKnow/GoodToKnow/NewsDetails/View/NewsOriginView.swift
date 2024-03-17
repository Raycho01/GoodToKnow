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
        stackView.spacing = 10
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let author: String?
    private let source: String?
    private let publishedAt: String?
    
    init(frame: CGRect, author: String?, source: String?, publishedAt: String?) {
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
        backgroundColor = UIColor.MainColors.lightBackground
        roundCorners()
        addSubview(vStackView)
        vStackView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        if let author = author {
            addRow(icon: "person.fill", firstText: "Author:", secondText: author)
        }
        
        if let source = source {
            addRow(icon: "link.circle", firstText: "Source:", secondText: source)
        }
        
        if let publishedAt = publishedAt {
            addRow(icon: "calendar", firstText: "Published at:", secondText: publishedAt)
        }
    }
    
    private func addRow(icon: String, firstText: String, secondText: String) {
        let rowView = UIStackView()
        rowView.axis = .horizontal
        rowView.spacing = 10
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black
        rowView.addArrangedSubview(iconImageView)
        
        let firstLabel = UILabel()
        firstLabel.text = firstText
        rowView.addArrangedSubview(firstLabel)
        
        let secondLabel = UILabel()
        secondLabel.text = secondText
        secondLabel.textColor = UIColor.MainColors.secondaryText
        rowView.addArrangedSubview(secondLabel)
        
        vStackView.addArrangedSubview(rowView)
    }
}
