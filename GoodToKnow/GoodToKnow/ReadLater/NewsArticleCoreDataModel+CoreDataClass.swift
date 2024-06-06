//
//  NewsArticleCoreDataModel+CoreDataClass.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 6.06.24.
//
//

import Foundation
import CoreData

@objc(NewsArticleCoreDataModel)
public class NewsArticleCoreDataModel: NSManagedObject {

}

extension NewsArticleCoreDataModel {
    func mapToArticle() -> NewsArticle {
        NewsArticle(source: Source(id: self.sourceId, name: self.sourceName),
                                  author: self.author,
                                  title: self.title,
                                  description: self.descriptionText,
                                  url: self.url,
                                  urlToImage: self.urlToImage,
                                  publishedAt: self.publishedAt,
                                  content: self.content)
    }
    
    func mapFromArticle(article: NewsArticle) {
        self.sourceId = article.source.id
        self.sourceName = article.source.name
        self.author = article.author
        self.title = article.title
        self.descriptionText = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
}
