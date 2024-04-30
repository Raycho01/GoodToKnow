//
//  CategoryCollectionViewCell.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.04.24.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setDimensions(width: UIScreen.main.bounds.width / 2.8, height: UIScreen.main.bounds.width / 6)
        imageView.tintColor = UIColor.MainColors.primaryText
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
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func configure(with category: Category) {
        let categoryModel = category.getModel()
        imageView.image = UIImage(systemName: categoryModel.image)
        titleLabel.text = categoryModel.title
    }
    
    private func setupUI() {
        self.setShadow()
        self.backgroundColor = .clear
        addSubview(wrapperView)
        wrapperView.fillSuperview()
        wrapperView.centerInSuperview()
        
        wrapperView.addSubview(vStack)
        vStack.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
    }
}
