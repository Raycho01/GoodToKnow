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
    
    private init() {}
    
    func saveInterfaceStyle(_ style: UIUserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: "InterfaceStyle")
    }

    func retrieveInterfaceStyle() -> UIUserInterfaceStyle {
        if let rawValue = UserDefaults.standard.value(forKey: "InterfaceStyle") as? Int,
            let style = UIUserInterfaceStyle(rawValue: rawValue) {
            return style
        }
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
}
