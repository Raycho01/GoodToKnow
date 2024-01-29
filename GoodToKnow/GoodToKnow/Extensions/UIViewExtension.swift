//
//  UIViewExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import Foundation
import UIKit

extension UIView {

    // MARK: - Fill Superview

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom)
        ])
    }

    // MARK: - Center in Superview

    func centerInSuperview() {
        guard let superview = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }

    // MARK: - Set Dimensions

    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    // MARK: - Set Aspect Ratio

    func setAspectRatio(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: width/height),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: height/width)
        ])
    }
    
    // MARK: - Set Anchors with Optional Values

        func anchor(top: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat = 0,
                               bottom: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0,
                               leading: NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0,
                               trailing: NSLayoutXAxisAnchor? = nil, trailingConstant: CGFloat = 0) {
            translatesAutoresizingMaskIntoConstraints = false
            
            if let top = top {
                topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
            }
            if let bottom = bottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
            }
            if let leading = leading {
                leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
            }
            if let trailing = trailing {
                trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant).isActive = true
            }
    }
}
