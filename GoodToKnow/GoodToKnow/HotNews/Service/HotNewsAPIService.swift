//
//  HotNewsAPIService.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation

final class HotNewsAPIService {
    
    private let apiKey = "b14913d1d32642cf83d5ddae86ffbf7c"
    private let baseURL = "https://newsapi.org/v2/top-headlines?"
    typealias NewsCompletion = (Result<NewsResponse, Error>) -> Void
    
    func fetchTopHeadlines(page: Int, filters: NewsSearchFilters, completion: @escaping NewsCompletion) {
        guard let url = URL(string: "\(baseURL)q=\(filters.keyword)&apiKey=\(apiKey)&page=\(page)&country=\(filters.country)") else {
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

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                completion(.success(newsResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

