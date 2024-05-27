//
//  UIViewExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import Foundation
import UIKit

extension UIView {

    // MARK: - Constraints

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

    func centerInSuperview() {
        guard let superview = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }

    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func setAspectRatio(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: width/height),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: height/width)
        ])
    }

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
    
    // MARK: - Round corners
    
    func roundCorners(_ corners: UIRectCorner = [.allCorners], radius: CGFloat = 20) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func roundCornersWithBorder(radius: CGFloat = 20, color: CGColor = UIColor.black.cgColor, width: CGFloat = 2) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    
    func setShadow(with radius: CGFloat = 4) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset =  CGSize.zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
    }
    
    func animate(from view1: UIView,
                 to view2: UIView,
                 disappearAnimationOptions: UIView.AnimationOptions? = nil,
                 appearAnimationOptions: UIView.AnimationOptions? = nil,
                 completion: (() -> Void)? = nil) {
        
        let defaultDisappearAnimationOptions: UIView.AnimationOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
        let defaultAppearAnimationOptions: UIView.AnimationOptions = [.transitionFlipFromTop, .showHideTransitionViews]

        UIView.transition(with: view1, duration: 0.3, options: disappearAnimationOptions ?? defaultDisappearAnimationOptions, animations: {
            view1.alpha = 0
        }) { _ in
            UIView.transition(with: view2, duration: 0.3, options: appearAnimationOptions ?? defaultAppearAnimationOptions, animations: {
                view2.alpha = 1
            }) { _ in
                completion?()
            }
        }
    }
}
