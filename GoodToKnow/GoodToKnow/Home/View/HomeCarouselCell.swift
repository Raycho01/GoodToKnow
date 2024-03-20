//
//  HomeCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 18.03.24.
//

import UIKit

class HomeCarouselCell: UICollectionViewCell {
    
    static let identifier = "HomeCarouselCell"
    private let cornerRadius: CGFloat = 20
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.6)
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: HomeCarouselModel) {
        imageView.setImage(with: model.image)
        titleLabel.text = model.value
    }
    
    private func setupUI() {
        layer.cornerRadius = cornerRadius
        self.backgroundColor = UIColor.MainColors.lightBackground
        self.setShadow()
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, topConstant: -10,
                          bottom: bottomAnchor)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}


