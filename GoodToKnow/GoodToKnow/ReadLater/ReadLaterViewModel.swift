//
//  ReadLaterViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 6.06.24.
//

import Foundation

final class ReadLaterViewModel: NewsListViewModelProtocol {
    
    var newsResponse: NewsResponse?
    
    var headerModel: NewsListHeaderViewModel = NewsListHeaderViewModel(title: "Saved articles", shouldShowSearch: false)
    
    var isCurrenltyLoading: ((Bool) -> Void) = { _ in }
    
    var newsResponseDidUpdate: ((NewsResponse?) -> Void) = { _ in }
    
    var filtersDidUpdate: ((NewsSearchFilters) -> Void) = { _ in }
    
    var onError: ((any Error) -> Void) = { _ in }
    
    private let coreDataManager = CoreDataManager.shared
    
    func fetchNewsInitially() {
        isCurrenltyLoading(true)
        let savedArticles = coreDataManager.fetchArticles()
        isCurrenltyLoading(false)
        newsResponseDidUpdate(NewsResponse(status: "", totalResults: nil, articles: savedArticles))
    }
    
    func fetchMoreNews() {}
    
    func searchForKeyword(_ keyword: String) {}
    
    func clearFilters() {}
    
}
