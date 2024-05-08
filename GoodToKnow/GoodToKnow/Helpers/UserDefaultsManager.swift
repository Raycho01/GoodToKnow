//
//  UserDefaultsManager.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 31.03.24.
//

import Foundation
import UIKit

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func saveInterfaceStyle(_ style: UIUserInterfaceStyle) {
        userDefaults.set(style.rawValue, forKey: "InterfaceStyle")
    }

    func retrieveInterfaceStyle() -> UIUserInterfaceStyle {
        if let rawValue = userDefaults.value(forKey: "InterfaceStyle") as? Int,
            let style = UIUserInterfaceStyle(rawValue: rawValue) {
            return style
        }
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
}
