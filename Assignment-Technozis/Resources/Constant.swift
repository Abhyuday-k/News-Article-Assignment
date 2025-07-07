//
//  Constant.swift
//  Assignment-Technozis
//
//  Created by abh on 06/07/25.
//

enum UserType: String {
    case reviewer = "Reviewer"
    case author = "Author"
}

enum MarkApproveError: Error {
    case nothingToApprove
    case saveFailed(String)
}

let kConstantUserName = "userName"
let kConstantUserType = "userRole"
