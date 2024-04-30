//
//  GlobalSearchFilters.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.04.24.
//

import Foundation

final class GlobalSearchFilters {
    
    static let shared = GlobalSearchFilters()
    
    var searchFilters = NewsSearchFilters() {
        didSet {
            NotificationCenter.default.post(name: .searchFiltersDidChange, object: searchFilters)
        }
    }
    
    private init() {}
}
