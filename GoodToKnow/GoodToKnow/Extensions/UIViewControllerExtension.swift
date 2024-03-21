//
//  UIViewControllerExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.03.24.
//

import UIKit

extension UIViewController {
    
    public func showAlertPopup(title: NSAttributedString?, message: NSAttributedString?, preferredStyle: UIAlertController.Style = .alert, actions: [AlertPopupAction]) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
        
        if let attributedTitle = title {
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }
        
        if let attributedMessage = message {
            alert.setValue(attributedMessage, forKey: "attributedMessage")
        }
        
        alert.addActions(actions: actions)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}
