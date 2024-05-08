//
//  AllNewsViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 17.03.24.
//

import Foundation

final class AllNewsViewModel: NewsListViewModelProtocol, TabBarIndexProtocol {
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
    var headerModel: NewsListHeaderViewModel = NewsListHeaderViewModel(title: Strings.ScreenTitles.allNews, shouldShowSearch: true)
    var newsResponseDidUpdate: ((NewsResponse?) -> Void) = { _ in }
    var onError: ((Error) -> Void) = { _ in }
    var isCurrenltyLoading: ((Bool) -> Void) = { _ in }
    var filtersDidUpdate: ((NewsSearchFilters) -> Void) = { _ in }
    var tabBarIndex: Int
    
    private let apiService: AllNewsAPIServiceProtocol
    private let pageSize = 20
    private let firstPage = 1
    private var cursor: PaginationCursor?
    
    init(apiService: AllNewsAPIServiceProtocol = AllNewsAPIService(),
         searchFilters: NewsSearchFilters = NewsSearchFilters(),
         tabBarIndex: Int) {
        self.apiService = apiService
        self.tabBarIndex = tabBarIndex
    }
    
    func fetchNewsInitially() {
        filtersDidUpdate(searchFilters)
        isCurrenltyLoading(true)
        apiService.fetchEverything(page: firstPage, filters: searchFilters) { [weak self] result in
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
        
        apiService.fetchEverything(page: cursor.currentPage, filters: searchFilters) { [weak self] result in
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
    
    private func setupCursor() {
        let totalPages = MathHelper.ceilingDivision((newsResponse?.totalResults ?? 0), by: pageSize)
        cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
    }
}
