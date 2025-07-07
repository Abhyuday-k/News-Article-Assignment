import Foundation

class APIService {
    static let shared = APIService()
    
    // Article metadata (summary)
    let mockArticleMetadata: [[String: Any]] = [
        [
            "articleId": "ART001",
            "author": "Robert",
            "approveCount": 3
        ],
        [
            "articleId": "ART002",
            "author": "Aman",
            "approveCount": 2
        ],
        [
            "articleId": "ART003",
            "author": "Shubham",
            "approveCount": 2
        ],
        [
            "articleId": "ART004",
            "author": "Robert",
            "approveCount": 2
        ]
    ]
    
    // Article details (full)
    let articleDetailsArray: [[String: Any]] = [
        [
            "articleId": "ART001",
            "name": "Perfume",
            "article": "Perfumes are made from essential oils and aroma compounds.",
            "createdAt": "2024-12-01T10:30:00Z",
            "updatedAt": "2025-06-25T09:15:00Z",
            "approvedBy": ["Mark", "John", "James"]
        ],
        [
            "articleId": "ART002",
            "name": "Shampoo",
            "article": "Perfumes are made from essential oils and aroma compounds.",
            "createdAt": "2024-12-01T10:30:00Z",
            "updatedAt": "2025-06-25T09:15:00Z",
            "approvedBy": ["Mark", "John"]
        ],
        [
            "articleId": "ART003",
            "name": "Soap",
            "article": "Perfumes are made from essential oils and aroma compounds.",
            "createdAt": "2024-12-01T10:30:00Z",
            "updatedAt": "2025-06-25T09:15:00Z",
            "approvedBy": ["Mark", "John"]
        ],
        [
            "articleId": "ART004",
            "name": "Body Wash",
            "article": "Perfumes are made from essential oils and aroma compounds.",
            "createdAt": "2024-12-01T10:30:00Z",
            "updatedAt": "2025-06-25T09:15:00Z",
            "approvedBy": ["Mark", "John"]
        ]
    ]
    
    /// Fetch all article IDs (metadata)
    func fetchAllArticleIDs(completion: @escaping ([String]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let ids = self.mockArticleMetadata.compactMap { $0["articleId"] as? String }
            completion(ids)
        }
    }
    
    /// Fetch metadata (summary) for an article
    func fetchArticleMetadata(id: String, completion: @escaping ([String: Any]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let article = self.mockArticleMetadata.first(where: { $0["articleId"] as? String == id })
            completion(article)
        }
    }
    
    /// Fetch detail (author/article body) for an article
    func fetchArticleDetail(id: String, completion: @escaping ([String: Any]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let detail = self.articleDetailsArray.first(where: { ($0["articleId"] as? String) == id })
            completion(detail)
        }
    }
    
    /// Simulate PUT (upload) articles to server
    func putArticlesToServer(_ articles: [[String: Any]], completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(true)
        }
    }
}

