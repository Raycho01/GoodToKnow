//
//  HomeCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 18.03.24.
//

import UIKit

class HomeCarouselCell: UICollectionViewCell {
    
    static let identifier = "HomeCarouselCell"
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = self.frame.height / 8
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.MainColors.primaryText?.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.MainColors.secondaryText
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
        self.backgroundColor = .clear
        
        self.layer.cornerRadius = self.frame.height / 8
        self.setShadow()
        
        addSubview(imageContainerView)
        imageContainerView.anchor(top: topAnchor, bottom: bottomAnchor,
                                  leading: leadingAnchor,
                                  trailing: trailingAnchor)
        
        imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 1).isActive = true
        imageContainerView.addSubview(imageView)
        imageView.fillSuperview(padding: UIEdgeInsets(top: -45, left: -10, bottom: -45, right: -10))
        imageView.centerInSuperview()
        
//        addSubview(titleLabel)
//        titleLabel.anchor(top: imageContainerView.bottomAnchor, topConstant: 10,
//                          bottom: bottomAnchor)
//        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}


