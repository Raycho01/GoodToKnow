//
//  SearchFiltersObserver.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.04.24.
//

import Foundation

class SearchFiltersObserver {
    
    var filtersDidUpdate: ((NewsSearchFilters) -> Void)
    
    private var filtersObserver: NSObjectProtocol!
    
    init(filtersDidUpdate: @escaping (NewsSearchFilters) -> Void, fireInitially: Bool = true) {
        self.filtersDidUpdate = filtersDidUpdate
        setupObserver()
        if fireInitially {
            filtersDidUpdate(GlobalSearchFilters.shared.searchFilters)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(filtersObserver as Any)
    }
    
    private func setupObserver() {
        filtersObserver = NotificationCenter.default.addObserver(forName: .searchFiltersDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let filters = notification.object as? NewsSearchFilters else { return }
            self?.filtersDidUpdate(filters)
        }
    }
}
