//
//  UIImageViewExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        guard let cachedImage = ImageCache.shared.image(forKey: urlString) else {
            guard let url = URL(string: urlString) else { return }
            
            url.fetchImage { [weak self] image in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    self?.image = image
                    ImageCache.shared.set(image, forKey: urlString)
                }
            }
            return
        }
        
        self.image = cachedImage
    }
}
