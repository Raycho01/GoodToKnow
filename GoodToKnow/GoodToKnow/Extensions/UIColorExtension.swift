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
        static let primaryBackground = UIColor(named: "primaryBackground")
        static let headerBackground = UIColor.systemGray2
        static let tabBarBackground = UIColor.systemGray2 // UIColor(red: 0.68, green: 0.68, blue: 0.7, alpha: 0.85)
        static let lightBackground = UIColor(named: "veryLightBackground")
        static let veryLightBackground = UIColor(named: "veryLightBackground")

        
        // MARK: - Text
        static let primaryText = UIColor(named: "primaryText")
        static let secondaryText = UIColor.darkGray
        
        // MARK: - Other
        static let accentColor = UIColor(red: 0.07, green: 0.42, blue: 0.87, alpha: 1.0)
        static let errorColor = UIColor.red
    }
}
