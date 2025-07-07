//
//  LoginViewModel.swift
//  Assignment-Technozis
//
//  Created by abh on 07/07/25.
//
import Foundation

class LoginViewModel {
    var username: String = ""
    var isClickedOnSubmit:Bool = false
    
    var role: UserType {
        username.lowercased() == "robert" ? .author : .reviewer
    }
    
    func storeLogin() {
        UserDefaults.standard.set(username, forKey: kConstantUserName)
        UserDefaults.standard.set(role.rawValue, forKey: kConstantUserType)
    }
    
    func canProceedToNews() -> Bool {
        !PersistenceService.shared.fetchArticles().isEmpty
    }
    
    func syncArticles(completion: (() -> Void)? = nil) {
        APIService.shared.fetchAllArticleIDs { ids in
            let group = DispatchGroup()
            
            for id in ids {
                group.enter()
                // For each ID, fetch metadata and detail
                APIService.shared.fetchArticleMetadata(id: id) { metadata in
                    APIService.shared.fetchArticleDetail(id: id) { detail in
                        PersistenceService.shared.saveArticleAndDetail(
                            articleId: id,
                            articleStr: detail?["article"] as? String ?? "",
                            author: metadata?["author"] as? String ?? "",
                            desc: metadata?["desc"] as? String,
                            lastUpdated: metadata?["lastUpdated"] as? Date,
                            approvedBy: detail?["approvedBy"] as? [String],
                            name: detail?["name"] as? String ?? metadata?["name"] as? String,
                            approveCount: Int16(metadata?["approveCount"] as? Int ?? 0),
                            createdAt: detail?["createdAt"] as? String ?? "",
                            updatedAt: detail?["updatedAt"] as? String ?? ""
                        )
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion?()
            }
        }
    }
}
