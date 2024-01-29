//
//  UIFontExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 29.01.24.
//

import Foundation
import UIKit

extension UIFont {
    
    static func getCopperplateFont(size: CGFloat = 20) -> UIFont {
        UIFont(name: "Copperplate", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
