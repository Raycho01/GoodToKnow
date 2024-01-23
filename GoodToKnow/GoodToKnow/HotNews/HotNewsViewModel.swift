//
//  HotNewsViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import Foundation

final class HotNewsViewModel {
    
    private let apiService: HotNewsAPIService!
    private(set) var newsResponse: NewsResponse? {
        didSet {
            newsResponseDidUpdate()
        }
    }
    
    var newsResponseDidUpdate : (() -> ()) = {}
    
    init() {
        apiService = HotNewsAPIService()
        callAPI()
    }
    
    private func callAPI() {
        
        apiService.fetchTopHeadlines { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResponse):
                self?.newsResponse = newsResponse
            }
        }
    }
        
}
