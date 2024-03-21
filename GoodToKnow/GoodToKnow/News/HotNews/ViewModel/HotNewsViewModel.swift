//
//  HotNewsViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import Foundation

protocol NewsListViewModelProtocol {
    
    var searchFilters: NewsSearchFilters { get set }
    var headerModel: NewsListHeaderViewModel { get set }
    var isCurrentlyFetching: Bool { get }
    var newsResponseDidUpdate : ((NewsResponse?) -> Void) { get set }
    var onError: ((Error) -> Void) { get set }
    
    func fetchNewsInitially()
    func fetchMoreNews()
}

final class HotNewsViewModel: NewsListViewModelProtocol, TabBarIndexProtocol {
    
    private let apiService: HotNewsAPIServiceProtocol!
    private(set) var newsResponse: NewsResponse? {
        didSet {
            newsResponseDidUpdate(newsResponse)
        }
    }
    var searchFilters = NewsSearchFilters() {
        didSet {
            cursor?.resetCursor()
            fetchNewsInitially()
        }
    }
    var headerModel: NewsListHeaderViewModel = NewsListHeaderViewModel(title: "Hot News", shouldShowSearch: false)
    
    private(set) var isCurrentlyFetching: Bool = false
    var newsResponseDidUpdate: ((NewsResponse?) -> Void) = { _ in }
    var onError: ((Error) -> Void) = { _ in }
    var tabBarIndex: Int
    
    private let pageSize = 20
    private let firstPage = 1
    private var cursor: PaginationCursor?
    
    init(apiService: HotNewsAPIServiceProtocol = HotNewsAPIService(),
         tabBarIndex: Int) {
        self.apiService = apiService
        self.tabBarIndex = tabBarIndex
        fetchNewsInitially()
    }
    
    func fetchNewsInitially() {
        isCurrentlyFetching = true
        apiService.fetchTopHeadlines(page: firstPage, filters: searchFilters) { [weak self] result in
            self?.isCurrentlyFetching = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.onError(error)
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
        
        apiService.fetchTopHeadlines(page: cursor.currentPage, filters: searchFilters) { [weak self] result in
            self?.isCurrentlyFetching = false
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.onError(error)
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
