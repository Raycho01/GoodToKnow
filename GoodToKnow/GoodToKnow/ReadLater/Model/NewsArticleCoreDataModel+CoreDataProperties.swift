//
//  NewsArticleCoreDataModel+CoreDataProperties.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 6.06.24.
//
//

import Foundation
import CoreData


extension NewsArticleCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticleCoreDataModel> {
        return NSFetchRequest<NewsArticleCoreDataModel>(entityName: "NewsArticleCoreDataModel")
    }

    @NSManaged public var author: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var content: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var sourceId: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension NewsArticleCoreDataModel : Identifiable {

}
