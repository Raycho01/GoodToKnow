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
    
    private let pageSize = 20
    private let firstPage = 1
    private var cursor: PaginationCursor?
    
    private(set) var isCurrentlyFetching: Bool = false
    
    var newsResponseDidUpdate : (() -> ()) = {}
    
    init() {
        apiService = HotNewsAPIService()
        fetchHotNewsInitially()
    }
    
    private func fetchHotNewsInitially() {

        apiService.fetchTopHeadlines(page: firstPage) { [weak self] result in
            self?.isCurrentlyFetching = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResponse):
                self.newsResponse = newsResponse
                setupCursor()
                cursor?.incrementPage()
            }
        }
    }
    
    func fetchMoreHotNews() {
        
        guard let cursor = cursor, !cursor.isEndReached else { return }
        isCurrentlyFetching = true
        
        apiService.fetchTopHeadlines(page: cursor.currentPage) { [weak self] result in
            self?.isCurrentlyFetching = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResponse):
                self.newsResponse?.articles.append(contentsOf: newsResponse.articles)
                self.cursor?.incrementPage()
            }
        }
    }
    
    private func setupCursor() {
        if cursor == nil {
            let totalPages = MathHelper.ceilingDivision((newsResponse?.totalResults ?? firstPage), by: pageSize)
            cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
        }
    }
        
}
