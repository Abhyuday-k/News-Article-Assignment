//
//  NewsListViewModel.swift
//  Assignment-Technozis
//
//  Created by abh on 07/07/25.
//

import Foundation

class NewsListViewModel {
    // Grouped by author name: [Author: [ArticleData]]
    private(set) var groupedArticles: [String: [ArticleData]] = [:]
    private(set) var sectionTitles: [String] = []
    var checkMarkState:[IndexPath] = []
    var userName:String = UserDefaults.standard.string(forKey: kConstantUserName) ?? ""
    var userType:UserType? = UserType.init(rawValue: UserDefaults.standard.string(forKey: kConstantUserType) ?? "")

    // Flat array of ArticleData (for author UI, or all articles)
    private(set) var allArticles: [ArticleData] = []

    // MARK: - Public API
    func loadArticles(forReviewer: Bool, currentAuthor: String? = nil, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { // Background thread, optional if fetch is fast
            let articles = PersistenceService.shared.fetchArticles()
            
            DispatchQueue.main.async { // UI updates always on main
                self.allArticles = articles

                if forReviewer {
                    self.groupedArticles = [:]
                    for article in articles {
                        if let authorName = article.authorDetail?.author, !authorName.isEmpty {
                            self.groupedArticles[authorName, default: []].append(article)
                        }
                    }
                    self.sectionTitles = self.groupedArticles.keys.sorted()
                } else if let author = currentAuthor {
                    self.allArticles = articles.filter { $0.authorDetail?.author == author }
                }
                
                completion() // Notify completion (update UI, reload table, etc)
            }
        }
    }


    // For Reviewer TableView
    func numberOfSections() -> Int {
        return sectionTitles.count
    }

    func numberOfRows(in section: Int) -> Int {
        let author = sectionTitles[section]
        return groupedArticles[author]?.count ?? 0
    }

    func article(for indexPath: IndexPath) -> ArticleData? {
        let author = sectionTitles[indexPath.section]
        return groupedArticles[author]?[indexPath.row]
    }

    // For Author TableView (single section)
    func numberOfAuthorRows() -> Int {
        return allArticles.count
    }

    func authorArticle(at row: Int) -> ArticleData? {
        return allArticles[safe: row]
    }
    
    func totalApproveCount(forSection section: Int) -> Int16 {
        let author = sectionTitles[section]
        let articles = groupedArticles[author] ?? []
        // Sum the approveCounts from each article's authorDetail
        return articles.reduce(0) {
            $0 + ($1.authorDetail?.approveCount ?? 0)
        }
    }
    
    
    func markApprove(
        selectedIndexPaths: [IndexPath],
        userType: UserType,
        userName: String,
        completion: ((Result<Void, MarkApproveError>) -> Void)? = nil
    ) {
        var didUpdate = false

        for indexPath in selectedIndexPaths {
            let article: ArticleData?
            if userType == .reviewer {
                article = self.article(for: indexPath)
            } else {
                article = self.authorArticle(at: indexPath.row)
            }
            guard let art = article else { continue }

            var approvedBy = (art.approvedBy as? [String]) ?? []
            if !approvedBy.contains(userName) {
                approvedBy.append(userName)
                art.approvedBy = approvedBy as NSArray
                if let authorDetail = art.authorDetail {
                    authorDetail.approveCount += 1
                }
                didUpdate = true
            }
        }

        if didUpdate {
            do {
                PersistenceService.shared.saveContext()
                // Reload latest data before reporting success
                self.loadArticles(forReviewer: (userType == .reviewer)) {
                    completion?(.success(()))
                }
            } catch {
                completion?(.failure(.saveFailed(error.localizedDescription)))
            }
        } else {
            // No object needed approval
            completion?(.failure(.nothingToApprove))
        }
    }



    
}

// Swift array safe subscript helper
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

