//
//  NewsArtkca.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.01.24.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

struct NewsArticle: Codable {
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String
}

struct Source: Codable {
    let id: String
    let name: String
}
