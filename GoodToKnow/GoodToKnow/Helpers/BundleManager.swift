//
//  BundleManager.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import Foundation

final class BundleManager {
    
    static let shared = BundleManager()
    
    private init() {}
    
    func getResource<T: Decodable>(resourceName: String, resultType: T.Type) -> T? {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: resourceName, withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch {
            return nil
        }
    }
}
