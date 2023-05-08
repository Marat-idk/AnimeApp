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
    case userDelete(id: String)
    case loginEmail(email: String, password: String)
    case loginUsername(username: String, password: String)
    case passwordResetEmail(email: String)
    case passwordReset(code: String, email: String, newPassword: String, repeatPassword: String)
    case updateUsername(id: String, username: String)
    case updateEmail(id: String, email: String)
}

extension AuthorizationRequest: RequestProtocol {
    
    private var accessToken: String {
        return "Bearer NzBjZDgyMTctODc4NC00NjExLWE1OGQtNmU3MmMwNjk5MjQz"
    }
    
    var baseURL: String {
        return "https://api.m3o.com/v1/"
    }
    
    var path: String {
        switch self {
        case .userCreate:
            return "user/Create"
        case .userDelete:
            return "user/Delete"
        case .loginEmail, .loginUsername:
            return "user/Login"
        case .passwordResetEmail:
            return "user/SendPasswordResetEmail"
        case .passwordReset:
            return "user/ResetPassword"
        case .updateUsername, .updateEmail:
            return "user/Update"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .userCreate:
            return .post
        case .userDelete:
            return .post
        case .loginEmail, .loginUsername:
            return .post
        case .passwordResetEmail:
            return .post
        case .passwordReset:
            return .post
        case .updateUsername, .updateEmail:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json",
                "Authorization": accessToken]
    }
    
    var body: HTTPBody? {
        switch self {
        case .loginUsername(let username, let password):
            return ["username": username, "password": password]
        case .userDelete(let id):
            return ["id": id]
        case .userCreate(let email, let password, let username):
            return ["email": email, "password": password, "username": username]
        case .loginEmail(let email, let password):
            return ["email": email, "password": password]
        case .passwordResetEmail(let email):
            return ["email": email, "textContent": "click here to reset your password: myapp.com/reset/code?=$code"]
        case .passwordReset(let code, let email, let newPassword, let repeatPassword):
            return ["code": code, "email": email, "newPassword": newPassword, "confirmPassword": repeatPassword]
        case .updateUsername(let id, let username):
            return ["id": id, "username": username]
        case .updateEmail(let id, let email):
            return ["id": id, "email": email]
        }
    }
    
}
