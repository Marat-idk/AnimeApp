//
//  AuthorizationRequest.swift
//  AnimeApp
//
//  Created by Marat on 17.04.2023.
//

import Foundation

// MARK: - AuthorizationRequest
enum AuthorizationRequest {
    case userCreate(email: String, password: String, username: String)
//    case userDelete
    case usersList
//    case
}

extension AuthorizationRequest: RequestProtocol {
    var baseURL: String {
        return "https://api.m3o.com/v1/"
    }
    
    var path: String {
        switch self {
        case .userCreate:
            return "user/Create"
        case .usersList:
            return "user/List"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .userCreate:
            return .post
        case .usersList:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer NzBjZDgyMTctODc4NC00NjExLWE1OGQtNmU3MmMwNjk5MjQz"]
    }
    
    var body: HTTPBody? {
        switch self {
        case .userCreate(let email, let password, let username):
            return ["email": email, "password": password, "username": username]
        case .usersList:
            return [:]
        }
    }
    
}
