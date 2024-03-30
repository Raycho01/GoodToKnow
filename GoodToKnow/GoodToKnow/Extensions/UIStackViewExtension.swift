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
}
