//
//  WideRectListView.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 10.04.24.
//

import Foundation
import UIKit

struct WideRectListViewModel {
    let icon: String
    let value: String
}

final class WideRectListView: UIView {
    
    private let items: [WideRectListViewModel]
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    init(items: [WideRectListViewModel]) {
        self.items = items
        super.init(frame: .zero)
        setupUI()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(vStack)
        vStack.fillSuperview()
        vStack.centerInSuperview()
    }
    
    private func setupStackView() {
        items.forEach { item in
            vStack.addArrangedSubview(createView(with: item))
        }
    }
    
    private func createView(with item: WideRectListViewModel) -> UIView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: item.icon) {
            imageView.image = image
        } else {
            imageView.setImage(with: item.icon)
        }
        hStack.addArrangedSubview(imageView)
        
        let label = UILabel()
        label.textColor = UIColor.MainColors.secondaryText
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = item.value
        hStack.addArrangedSubview(label)
        
        return hStack
    }
}
