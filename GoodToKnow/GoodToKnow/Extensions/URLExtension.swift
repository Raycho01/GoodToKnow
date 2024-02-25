//
//  URLExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 25.02.24.
//

import Foundation
import UIKit

extension URL {
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to convert data to image")
                completion(nil)
            }
        }.resume()
    }
}
