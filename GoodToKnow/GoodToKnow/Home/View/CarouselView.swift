//
//  CarouselView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import UIKit
import Combine

protocol CarouselViewDelegate: AnyObject {
    func didTapOnCarouselCell(with value: String)
}

final class CarouselView: UIView {
    
    private var carouselModels: [CarouselModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var cancellables: [AnyCancellable] = []
    
    private let viewModel: CarouselViewModelProtocol
    weak var delegate: CarouselViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.MainColors.secondaryText
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "Countries"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 70)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)

        return collectionView
    }()
    
    init(viewModel: CarouselViewModelProtocol, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor, leadingConstant: 10,
                          trailing: trailingAnchor)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, topConstant: 10,
                              bottom: bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor)
    }
    
    private func bindToViewModel() {
        viewModel.bind().receive(on: RunLoop.main).sink { [weak self] carouselModels in
            self?.carouselModels = carouselModels
        }.store(in: &cancellables)
    }
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carouselModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as? CarouselCell 
        else { return UICollectionViewCell() }
        
        cell.configure(with: carouselModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapOnCarouselCell(with: carouselModels[indexPath.row].value)
    }
}
