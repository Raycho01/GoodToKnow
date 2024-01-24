//
//  PaginationCursor.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 23.01.24.
//

import Foundation

struct PaginationCursor {
    private(set) var currentPage: Int
    let totalPages: Int
    let pageSize: Int
    
    private(set) var isEndReached: Bool
    
    init(totalPages: Int, pageSize: Int) {
        self.currentPage = 1
        self.totalPages = totalPages
        self.pageSize = pageSize
        self.isEndReached = false
    }
    
    mutating func incrementPage() {
        guard isEndReached == false else { return }
        
        
        
        if currentPage >= totalPages {
            isEndReached = true
        } else {
            currentPage += 1
        }
    }
    
    mutating func resetCursor() {
        currentPage = 1
        isEndReached = false
    }
}
