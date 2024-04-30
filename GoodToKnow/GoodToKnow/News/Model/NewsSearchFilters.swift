//
//  NewsSearchFilters.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 18.02.24.
//

import Foundation

struct NewsSearchFilters {
    var keyword: String = ""
    var country: String = "us" // workaround, because of the API
    var category: String = ""
}
