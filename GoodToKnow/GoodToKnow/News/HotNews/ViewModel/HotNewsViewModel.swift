//
//  HotNewsViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import Foundation

protocol NewsListViewModelProtocol {
    
    var newsResponse: NewsResponse? { get }
    var headerModel: NewsListHeaderViewModel { get set }
    var isCurrenltyLoading: ((Bool) -> Void) { get set }
    var newsResponseDidUpdate : ((NewsResponse?) -> Void) { get set }
    var filtersDidUpdate: ((NewsSearchFilters) -> Void) { get set }
    var onError: ((Error) -> Void) { get set }
    
    func fetchNewsInitially()
    func fetchMoreNews()
    func searchForKeyword(_ keyword: String)
    func clearFilters()
}

final class HotNewsViewModel: NewsListViewModelProtocol, TabBarIndexProtocol {
    
    private let apiService: HotNewsAPIServiceProtocol!
    private(set) var newsResponse: NewsResponse? {
        didSet {
            newsResponseDidUpdate(newsResponse)
        }
    }
    lazy var searchFilters = NewsSearchFilters() {
        didSet {
            cursor?.resetCursor()
            fetchNewsInitially()
            filtersDidUpdate(searchFilters)
        }
    }
    var headerModel: NewsListHeaderViewModel = NewsListHeaderViewModel(title: Strings.ScreenTitles.hotNews, shouldShowSearch: true)
    
    var newsResponseDidUpdate: ((NewsResponse?) -> Void) = { _ in }
    var onError: ((Error) -> Void) = { _ in }
    var isCurrenltyLoading: ((Bool) -> Void) = { _ in }
    var tabBarIndex: Int
    var filtersDidUpdate: ((NewsSearchFilters) -> Void) = { _ in }
    
    private let pageSize = 20
    private let firstPage = 1
    private var cursor: PaginationCursor?
    
    init(apiService: HotNewsAPIServiceProtocol = HotNewsAPIService(),
         tabBarIndex: Int) {
        self.apiService = apiService
        self.tabBarIndex = tabBarIndex
    }
    
    func fetchNewsInitially() {
        filtersDidUpdate(searchFilters)
        isCurrenltyLoading(true)
        apiService.fetchTopHeadlines(page: firstPage, filters: searchFilters) { [weak self] result in
            self?.isCurrenltyLoading(false)
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
        isCurrenltyLoading(true)
        
        apiService.fetchTopHeadlines(page: cursor.currentPage, filters: searchFilters) { [weak self] result in
            self?.isCurrenltyLoading(false)
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
    
    func searchForKeyword(_ keyword: String) {
        searchFilters.keyword = keyword
    }
    
    func clearFilters() {
        searchFilters = NewsSearchFilters()
    }
    
    func searchForCountry(_ country: String) {
        searchFilters.country = country
    }
    
    func searchForCategory(_ category: String) {
        searchFilters.category = category
    }
    
    private func setupCursor() {
        let totalPages = MathHelper.ceilingDivision((newsResponse?.totalResults ?? 0), by: pageSize)
        cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
    }
}
