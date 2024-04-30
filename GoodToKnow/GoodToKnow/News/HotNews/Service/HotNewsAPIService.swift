//
//  HotNewsAPIService.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation

protocol HotNewsAPIServiceProtocol {
    typealias NewsCompletion = (Result<NewsResponse, Error>) -> Void
    func fetchTopHeadlines(page: Int, filters: NewsSearchFilters, completion: @escaping NewsCompletion)
}

final class HotNewsAPIService: HotNewsAPIServiceProtocol {
    
    private let apiKey = "b14913d1d32642cf83d5ddae86ffbf7c"
    private let baseURL = "https://newsapi.org/v2/top-headlines?"
    
    func fetchTopHeadlines(page: Int, filters: NewsSearchFilters, completion: @escaping NewsCompletion) {
        guard let url = URL(string: "\(baseURL)q=\(filters.keyword)&apiKey=\(apiKey)&page=\(page)&country=\(filters.country)&category=\(filters.category)") else {
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
            
            // Print the fetched JSON data
            if let json = String(data: data, encoding: .utf8) {
                print("\n\n\n\n\nJSON Response: \(json)\n\n\n\n\n")
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

