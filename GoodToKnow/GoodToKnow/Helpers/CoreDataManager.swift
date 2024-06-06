//
//  CoreDataManager.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 6.06.24.
//

import Foundation

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsArticlesCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchArticles() -> [NewsArticle] {
        let fetchRequest: NSFetchRequest<NewsArticleCoreDataModel> = NewsArticleCoreDataModel.fetchRequest()
        
        do {
            let coreDataArticles = try context.fetch(fetchRequest)
            let articles = coreDataArticles.map({ $0.mapToArticle() })
            return articles
        } catch {
            print("Failed to fetch articles: \(error)")
            return []
        }
    }
    
    func saveArticle(article: NewsArticle) {
        let coreDataArticle = NewsArticleCoreDataModel(context: context)
        coreDataArticle.mapFromArticle(article: article)
        saveContext()
    }

}
