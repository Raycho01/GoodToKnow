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
    
    func fetchArticles(completion: @escaping ([NewsArticle]) -> Void) {
        let fetchRequest: NSFetchRequest<NewsArticleCoreDataModel> = NewsArticleCoreDataModel.fetchRequest()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let coreDataArticles = try self?.context.fetch(fetchRequest)
                let articles = coreDataArticles?.compactMap({ $0.mapToArticle() })
                DispatchQueue.main.async {
                    completion(articles ?? [])
                }
            } catch {
                print("Failed to fetch articles: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func saveArticle(article: NewsArticle) {
        guard let articleTitle = article.title else { return }
        
        getArticleBy(title: articleTitle) { [weak self] articleCoreData in
            guard articleCoreData == nil, let self = self else { return }
            
            let coreDataArticle = NewsArticleCoreDataModel(context: context)
            coreDataArticle.mapFromArticle(article: article)
            saveContext()
        }
    }
    
    func deleteArticle(article: NewsArticle) {
        guard let articleTitle = article.title else { return }
        getArticleBy(title: articleTitle) { [weak self] article in
            guard let article = article, let self = self else { return }
            context.delete(article)
            saveContext()
        }
    }
    
    private func getArticleBy(title: String, completion: @escaping (NewsArticleCoreDataModel?) -> Void) {
        let fetchRequest: NSFetchRequest<NewsArticleCoreDataModel> = NewsArticleCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title as CVarArg)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                let coreDataArticles = try self.context.fetch(fetchRequest)
                guard let coreDataArticle = coreDataArticles.first else {
                    completion(nil)
                    return
                }
                completion(coreDataArticle)
            } catch {
                completion(nil)
                print("Failed to delete article: \(error)")
            }
        }
    }
}
