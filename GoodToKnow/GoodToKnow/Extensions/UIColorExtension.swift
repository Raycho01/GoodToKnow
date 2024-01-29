//
//  UIColorExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 24.01.24.
//

import Foundation
import UIKit

extension UIColor {
    
    struct MainColors {
        
        // MARK: - Background
        static let primaryBackground = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        static let headerBackground = UIColor.systemRed
        static let tabBarBackground = UIColor.systemGray2
        
        // MARK: - Text
        static let primaryText = UIColor.black
        static let secondaryText = UIColor.darkGray
        
        // MARK: - Other
        static let accentColor = UIColor(red: 0.07, green: 0.42, blue: 0.87, alpha: 1.0)
        static let separatorColor = UIColor.lightGray
        static let errorColor = UIColor.red
    }
}
