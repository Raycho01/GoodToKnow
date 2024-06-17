//
//  ReadLaterViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 6.06.24.
//

import Foundation

final class ReadLaterViewModel: ReadLaterViewModelProtocol {
    
    var newsArticles: [NewsArticle] = []
    
    var newsDidUpdate: (() -> Void) = {}
    
    var isCurrenltyLoading: ((Bool) -> Void) = { _ in }
    
    private let coreDataManager = CoreDataManager.shared
    
    func fetchNews() {
        isCurrenltyLoading(true)
        coreDataManager.fetchArticles(completion: { [weak self] articles in
            self?.isCurrenltyLoading(false)
            self?.newsArticles = articles
            self?.newsDidUpdate()
        })
    }
    
    func removeArticle(at index: Int) {
        coreDataManager.deleteArticle(article: newsArticles[index])
        newsArticles.remove(at: index)
    }
}
