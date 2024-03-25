//
//  AllNewsAPIService.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 17.03.24.
//

import Foundation

protocol AllNewsAPIServiceProtocol {
    typealias NewsCompletion = (Result<NewsResponse, Error>) -> Void
    func fetchEverything(page: Int, filters: NewsSearchFilters, completion: @escaping NewsCompletion)
}

final class AllNewsAPIService: AllNewsAPIServiceProtocol {
    
    private let apiKey = "b14913d1d32642cf83d5ddae86ffbf7c"
    private let baseURL = "https://newsapi.org/v2/everything?"
    
    func fetchEverything(page: Int, filters: NewsSearchFilters, completion: @escaping NewsCompletion) {
        // needed workaround, because of the API
        let keyword = filters.keyword.isEmpty ? "a" : filters.keyword
        
        guard let url = URL(string: "\(baseURL)q=\(keyword)&apiKey=\(apiKey)&page=\(page)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            // Print the JSON response string for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                var newsResponse = try decoder.decode(NewsResponse.self, from: data)
                
                // needed workaround, because of the API
                newsResponse.articles = newsResponse.articles.filter({ $0.title != "[Removed]" })
                
                completion(.success(newsResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
