//
//  HomeCarouselView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import UIKit
import Combine

protocol HomeCarouselViewDelegate: AnyObject {
    func didTapOnCell(with value: String, type: HomeCarouselView.HomeCarouselType)
}

final class HomeCarouselView: UIView {
    
    enum HomeCarouselType {
        case country
        case date
    }
    private let type: HomeCarouselType
    
    private var carouselModels: [HomeCarouselModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var cancellables: [AnyCancellable] = []
    
    private let viewModel: HomeCarouselViewModelProtocol
    weak var delegate: HomeCarouselViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Countries"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 150)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeCarouselCell.self, forCellWithReuseIdentifier: HomeCarouselCell.identifier)

        return collectionView
    }()
    
    init(viewModel: HomeCarouselViewModelProtocol, type: HomeCarouselType, frame: CGRect) {
        self.viewModel = viewModel
        self.type = type
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

extension HomeCarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carouselModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCarouselCell.identifier, for: indexPath) as? HomeCarouselCell 
        else { return UICollectionViewCell() }
        
        cell.configure(with: carouselModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapOnCell(with: carouselModels[indexPath.row].value, type: type)
    }
}