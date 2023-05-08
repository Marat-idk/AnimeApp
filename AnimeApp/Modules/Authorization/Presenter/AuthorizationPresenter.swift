//
//  AuthorizationPresenter.swift
//  AnimeApp
//
//  Created by Marat on 23.04.2023.
//

import Foundation

// MARK: - AuthorizationLoginType
enum AuthorizationLoginType {
    case email
    case username
}

// MARK: - AuthorizationViewProtocol
protocol AuthorizationViewProtocol: AnyObject {
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func loginFailure(error: String)
    func loginSuccess()
}

// MARK: - AuthorizationPresenterProtocol
protocol AuthorizationPresenterProtocol: AnyObject {
    init(view: AuthorizationViewProtocol)
    func signIn(login: String, password: String, completion: @escaping (Bool) -> Void)
    func signUp(email: String, username: String, password: String, completion: @escaping (Bool) -> Void)
}

// MARK: - AuthorizationPresenter
final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    weak var view: AuthorizationViewProtocol?
    
    private let userService = UserService.shared
    private var authorization = Authorization()
    private var authorizationType: AuthorizationLoginType?
    private var authorizationValidation: AuthorizationValidation?
    private var registration = Registration()
    private var registrationValidation = RegistrationValidation()
    
    init(view: AuthorizationViewProtocol) {
        self.view = view
    }
    
    // MARK: - protocol methods
    func signIn(login: String, password: String, completion: @escaping (Bool) -> Void) {
        
        if login.contains("@") {
            authorization.email = login
            authorizationType = .email
        } else {
            authorization.username = login
            authorizationType = .username
        }
        authorization.password = password
        
        authorizationValidation = AuthorizationValidation(type: authorizationType ?? .username)
        
        if let error = authorizationValidation?.validate(model: authorization) {
            view?.loginFailure(error: error.localizedDescription)
            completion(true)
            return
        }
        
        switch authorizationType {
        case .email:
            signInEmail(model: authorization) { isSuccesed in
                completion(isSuccesed)
            }
        case .username:
            signInUsername(model: authorization) { isSuccesed in
                completion(isSuccesed)
            }
        default:
            return
        }
    }
    
    func signUp(email: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        
        registration.email = email
        registration.username = username
        registration.password = password
        
        if let error = registrationValidation.validate(model: registration) {
            view?.loginFailure(error: error.localizedDescription)
        }
        
        sugnUp(model: registration) { isSuccesed in
            completion(isSuccesed)
        }
    }
    
    // MARK: - private methods
    private func signInEmail(model: Authorization, completion: @escaping (Bool) -> Void) {
        guard let email = model.email,
              let password = model.password else { return }
        
        userService.login(email: email, and: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.view?.loginFailure(error: error.localizedDescription)
                case .success(let data):
                    if let jsonData = data as? [String: Any], let error = jsonData["detail"] as? String {
                        self?.view?.loginFailure(error: error)
                        completion(true)
                        return
                    }
                    if self?.userService.session != nil {
                        self?.view?.loginSuccess()
                        completion(true)
                        return
                    }
                    self?.view?.loginFailure(error: "Unknown error. Try leter")
                    completion(false)
                }
            }
        }
    }
    
    private func signInUsername(model: Authorization, completion: @escaping (Bool) -> Void) {
        
        guard let username = model.username,
              let password = model.password else { return }
        
        userService.login(username: username, and: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.view?.loginFailure(error: error.localizedDescription)
                case .success(let data):
                    if let jsonData = data as? [String: Any], let error = jsonData["detail"] as? String {
                        self?.view?.loginFailure(error: error)
                        completion(true)
                        return
                    }
                    if self?.userService.session != nil {
                        self?.view?.loginSuccess()
                        completion(true)
                        return
                    }
                    self?.view?.loginFailure(error: "Unknown error. Try leter")
                    completion(true)
                }
            }
        }
    }
    
    private func sugnUp(model: Registration, completion: @escaping (Bool) -> Void) {
        guard let email = model.email,
              let username = model.username,
              let password = model.password else { return }
        
        userService.registration(email: email, username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.view?.loginFailure(error: error.localizedDescription)
                case .success(let data):
                    if let jsonData = data as? [String: Any], let error = jsonData["detail"] as? String {
                        self?.view?.loginFailure(error: error)
                        completion(true)
                        return
                    }
                    if self?.userService.user != nil {
                        self?.view?.loginSuccess()
                        completion(true)
                        return
                    }
                    self?.view?.loginFailure(error: "Unknown error. Try leter")
                    completion(true)
                }
            }
        }
    }
}
