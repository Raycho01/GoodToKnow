//
//  UIStackViewExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.03.24.
//

import UIKit

extension UIStackView {
    
    func removeAllSubviews() {
        self.subviews.forEach({
            $0.removeFromSuperview()
            $0.isHidden = true
        })
    }
    
    func addSeparatorView() {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .black.withAlphaComponent(0.1)
        self.addArrangedSubview(separator)
        separator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.98).isActive = true
    }
}
