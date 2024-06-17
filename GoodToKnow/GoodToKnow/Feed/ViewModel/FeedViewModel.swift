//
//  FeedViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 26.05.24.
//

import Foundation
import UIKit

protocol FeedViewModelProtocol {
    
    var newsArticles: [NewsArticle?] { get set }
    var newsArticlesDidUpdate: (() -> Void) { get set }
    var isCurrenltyLoading: Bool { get }
    var onError: ((Error) -> Void) { get set }
    
    func fetchNewsInitially()
    func fetchMoreNews()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    var newsArticles: [NewsArticle?] = []
    var newsArticlesDidUpdate: (() -> Void) = {}
    var isCurrenltyLoading: Bool = false {
        didSet {
            handlePlaceholders()
        }
    }
    var onError: ((any Error) -> Void) = { _ in }

    var apiService: HotNewsAPIServiceProtocol
    private var cursor: PaginationCursor?
    private var totalResults: Int = 0
    
    init(apiService: HotNewsAPIServiceProtocol = HotNewsAPIService()) {
        self.apiService = apiService
    }
    
    func fetchNewsInitially() {
        newsArticles.removeAll()
        let firstPage = 1
        isCurrenltyLoading = true
        apiService.fetchTopHeadlines(page: firstPage, pageSize: cursor?.pageSize ?? 5, filters: NewsSearchFilters()) { [weak self] result in
            self?.isCurrenltyLoading = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.onError(error)
                break
            case .success(let newsResponse):
                self.newsArticles = newsResponse.articles
                newsArticlesDidUpdate()
                self.totalResults = newsResponse.totalResults ?? 0
                setupCursor()
                cursor?.incrementPage()
            }
        }
    }
    
    func fetchMoreNews() {
        guard let cursor = cursor, !cursor.isEndReached else { return }
        isCurrenltyLoading = true
        
        apiService.fetchTopHeadlines(page: cursor.currentPage, pageSize: cursor.pageSize, filters: NewsSearchFilters()) { [weak self] result in
            self?.isCurrenltyLoading = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.onError(error)
                break
            case .success(let newsResponse):
                self.newsArticles.append(contentsOf: newsResponse.articles)
                newsArticlesDidUpdate()
                self.cursor?.incrementPage()
            }
        }
    }
    
    private func handlePlaceholders() {
        if isCurrenltyLoading {
            newsArticles.append(nil)
        } else {
            newsArticles = newsArticles.filter({ $0 != nil })
        }
        newsArticlesDidUpdate()
    }
    
    private func setupCursor() {
        let pageSize = 5
        let totalPages = MathHelper.ceilingDivision((totalResults), by: pageSize)
        cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
    }
    
}
