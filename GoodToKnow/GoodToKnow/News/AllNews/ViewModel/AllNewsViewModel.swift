//
//  AllNewsViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 17.03.24.
//

import Foundation

final class AllNewsViewModel: NewsListViewModelProtocol {
    private(set) var newsResponse: NewsResponse? {
        didSet {
            newsResponseDidUpdate()
        }
    }
    var searchFilters = NewsSearchFilters() {
        didSet {
            cursor?.resetCursor()
            fetchNewsInitially()
        }
    }
    var isCurrentlyFetching: Bool = false
    var newsResponseDidUpdate: (() -> ()) = {}
    
    private let apiService: AllNewsAPIServiceProtocol
    private let pageSize = 20
    private let firstPage = 1
    private var cursor: PaginationCursor?
    
    init(apiService: AllNewsAPIServiceProtocol = AllNewsAPIService()) {
        self.apiService = apiService
        fetchNewsInitially()
    }
    
    private func fetchNewsInitially() {
        isCurrentlyFetching = true
        apiService.fetchEverything(page: firstPage, filters: searchFilters) { [weak self] result in
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
    
    func fetchMoreNews() {
        guard let cursor = cursor, !cursor.isEndReached else { return }
        isCurrentlyFetching = true
        
        apiService.fetchEverything(page: cursor.currentPage, filters: searchFilters) { [weak self] result in
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
        let totalPages = MathHelper.ceilingDivision((newsResponse?.totalResults ?? 0), by: pageSize)
        cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
    }
}
