//
//  UIImageViewExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import UIKit

extension UIImageView {
    
    private static var imageTasks: [String: URLSessionDataTask] = [:]
    
    func setImage(with urlString: String) {
        
        if let existingTask = UIImageView.imageTasks[urlString] {
            existingTask.cancel()
            UIImageView.imageTasks[urlString] = nil
        }
        
        guard let cachedImage = ImageCache.shared.image(forKey: urlString) else {
            self.image = UIImage.imagePlaceholder
            guard let url = URL(string: urlString) else { return }
            
            let task = url.fetchImage { [weak self] image in
                DispatchQueue.main.async {
                    UIImageView.imageTasks[urlString] = nil
                    guard let image = image else { return }
                    self?.image = image
                    ImageCache.shared.set(image, forKey: urlString)
                }
            }
            
            UIImageView.imageTasks[urlString] = task
            return
        }
        
        self.image = cachedImage
    }
}
