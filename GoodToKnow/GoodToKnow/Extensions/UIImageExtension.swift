//
//  UIImageExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 24.01.24.
//

import Foundation
import UIKit

extension UIImage {
    
    static let flagPlaceholder = UIImage(named: "flag_placeholder")
    
    func getFlagOf(country: String) -> UIImage {
        return UIImage(named: country) ?? UIImage.flagPlaceholder!
    }
}
