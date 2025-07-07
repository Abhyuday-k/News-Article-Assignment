//
//  PersistenceService.swift
//  Assignment-Technozis
//
//  Created by abh on 06/07/25.
//

import Foundation
import CoreData

class PersistenceService {
    static let shared = PersistenceService()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "OfflineData")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData load error: \(error)") }
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    
    /// Save or update ArticleData and AuthorData, and link them
    func saveArticleAndDetail(
        articleId: String,
        articleStr:String,
        author: String,
        desc: String?,
        lastUpdated: Date?,
        approvedBy: [String]?,
        name: String?,
        approveCount: Int16?,
        createdAt: String?,
        updatedAt: String?
    ) {
        // Try to fetch existing ArticleData
        let fetch: NSFetchRequest<ArticleData> = ArticleData.fetchRequest()
        fetch.predicate = NSPredicate(format: "articleId == %@", articleId)
        let article = (try? context.fetch(fetch))?.first ?? ArticleData(context: context)
        
        article.articleId = articleId
        article.approvedBy = approvedBy as NSArray?
        article.name = name ?? desc ?? ""
        article.createdAt = createdAt ?? ""
        article.updatedAt = updatedAt ?? ""
        article.article = articleStr
        
        // Try to fetch existing AuthorData
        let authorFetch: NSFetchRequest<AuthorData> = AuthorData.fetchRequest()
        authorFetch.predicate = NSPredicate(format: "articleId == %@", articleId)
        let authorDetail = (try? context.fetch(authorFetch))?.first ?? AuthorData(context: context)
        
        authorDetail.articleId = articleId
        authorDetail.author = author
        authorDetail.approveCount = approveCount ?? 0
        
        // Set relationships (bidirectional)
        article.authorDetail = authorDetail
        authorDetail.article = article
        
        do {
            try context.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    /// Fetch all articles
    func fetchArticles() -> [ArticleData] {
        let request: NSFetchRequest<ArticleData> = ArticleData.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data save failed: \(error)")
            }
        }
    }
}
