//
//  UIAlertControllerExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.03.24.
//

import UIKit

extension UIAlertController {
    
    public func addActions(actions: [AlertPopupAction]) {
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: UIAlertAction.Style(rawValue: action.style) ?? .default) { _ in
                action.action?()
            }
            
            self.addAction(alertAction)
            
            if action.isPreferred {
                self.preferredAction = alertAction
            }
        }
    }
}
