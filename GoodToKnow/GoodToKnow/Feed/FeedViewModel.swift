//
//  FeedViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 26.05.24.
//

import Foundation
import UIKit

protocol FeedViewModelProtocol {
    
    var newsArticles: [NewsArticle] { get }
    var newsArticlesDidUpdate: (() -> Void) { get set }
    var isCurrenltyLoading: Bool { get }
    
    func fetchNewsInitially()
    func fetchMoreNews()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    var newsArticles: [NewsArticle] = [] {
        didSet {
            newsArticlesDidUpdate()
        }
    }
    var newsArticlesDidUpdate: (() -> Void) = {}
    var isCurrenltyLoading: Bool = false
    
    var apiService: HotNewsAPIServiceProtocol
    private let pageSize = 3
    private let firstPage = 1
    private var cursor: PaginationCursor?
    private var totalResults: Int = 0
    
    init(apiService: HotNewsAPIServiceProtocol = HotNewsAPIService()) {
        self.apiService = apiService
    }
    
    func fetchNewsInitially() {
        isCurrenltyLoading = true
        apiService.fetchTopHeadlines(page: firstPage, filters: NewsSearchFilters()) { [weak self] result in
            self?.isCurrenltyLoading = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
//                self.onError(error)
                break
            case .success(let newsResponse):
                self.newsArticles = newsResponse.articles
                self.totalResults = newsResponse.totalResults ?? 0
                setupCursor()
                cursor?.incrementPage()
            }
        }
    }
    
    func fetchMoreNews() {
        guard let cursor = cursor, !cursor.isEndReached else { return }
        isCurrenltyLoading = true
        
        apiService.fetchTopHeadlines(page: cursor.currentPage, filters: NewsSearchFilters()) { [weak self] result in
            self?.isCurrenltyLoading = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
//                self.onError(error)
                break
            case .success(let newsResponse):
                self.newsArticles.append(contentsOf: newsResponse.articles)
                self.cursor?.incrementPage()
            }
        }
    }
    
    private func setupCursor() {
        let totalPages = MathHelper.ceilingDivision((totalResults), by: pageSize)
        cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
    }
    
}
