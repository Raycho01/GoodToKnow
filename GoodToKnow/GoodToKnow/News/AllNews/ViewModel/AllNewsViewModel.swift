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
    var searchFilters = NewsSearchFilters() {
        didSet {
            cursor?.resetCursor()
            fetchNewsInitially()
        }
    }
    var headerModel: NewsListHeaderViewModel = NewsListHeaderViewModel(title: "All News", shouldShowSearch: true)
    var newsResponseDidUpdate: ((NewsResponse?) -> Void) = { _ in }
    var onError: ((Error) -> Void) = { _ in }
    var isCurrenltyLoading: ((Bool) -> Void) = { _ in }
    var tabBarIndex: Int
    
    private let apiService: AllNewsAPIServiceProtocol
    private let pageSize = 20
    private let firstPage = 1
    private var cursor: PaginationCursor?
    private var filtersObserver: SearchFiltersObserver?
    
    init(apiService: AllNewsAPIServiceProtocol = AllNewsAPIService(),
         searchFilters: NewsSearchFilters = NewsSearchFilters(),
         tabBarIndex: Int) {
        self.apiService = apiService
        self.tabBarIndex = tabBarIndex
        setupObserver()
    }
    
    func fetchNewsInitially() {
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
    
    private func setupCursor() {
        let totalPages = MathHelper.ceilingDivision((newsResponse?.totalResults ?? 0), by: pageSize)
        cursor = PaginationCursor(totalPages: totalPages, pageSize: pageSize)
    }
    
    private func setupObserver() {
        filtersObserver = SearchFiltersObserver(filtersDidUpdate: { [weak self] filters in
            self?.searchFilters = filters
        })
    }
}
