//
//  UserService.swift
//  AnimeApp
//
//  Created by Marat on 18.04.2023.
//

import Foundation
import ObjectMapper

// MARK: - UserServiceComplition
typealias UserServiceCompletion = (Result<Any, Error>) -> Void

// MARK: - UserServiceProtocol
protocol UserServiceProtocol {
    var user: User? { get }
    var session: Session? { get }
    
    func login(email: String, and password: String, completion: @escaping UserServiceCompletion)
    func login(username: String, and password: String, completion: @escaping UserServiceCompletion)
    
    func registration(email: String, username: String, password: String, completion: @escaping UserServiceCompletion)
    
    func requestPasswordReset(email: String, completion: @escaping UserServiceCompletion)
    func resetPassword(code: String, newPassword: String, confirmPasword: String, email: String, completion: @escaping UserServiceCompletion)
    
    func updateUsername(id: String, newUsername: String, completion: @escaping UserServiceCompletion)
    func updateEmail(id: String, newEmail: String, completion: @escaping UserServiceCompletion)
    
    func updatePassword(oldPassword: String, newPassword: String, repeatPassword: String, completion: @escaping UserServiceCompletion)
    
    func delete(id: String, completion: @escaping UserServiceCompletion)
}

// MARK: - UserService
class UserService: UserServiceProtocol {
    
    static let shared = UserService()
    
    var user: User?
    var session: Session?
    
    private var networkManager: NetworkManager
    
    private init(networkManager: NetworkManager = NetworkManagerImpl()) {
        self.networkManager = networkManager
    }
    
    func login(email: String, and password: String, completion: @escaping UserServiceCompletion) {
        networkManager.request(with: AuthorizationRequest.loginEmail(email: email, password: password)) { data, _, error in
            
            guard error == nil else {
                completion(.failure(NetworkError.connectionFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataAvailable))
                return
            }
            
            do {
//                data.printJSON()

                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                // registration failed
                if let jsonData = jsonData, jsonData["detail"] != nil {
                    completion(.success(jsonData))
                    return
                }
                
                let session = Mapper<Session>().map(JSONObject: jsonData)
                self.session = session
                completion(.success(jsonData))
            } catch {
                completion(.failure(APIError.canNotProcessData))
            }
        }
    }
    
    func login(username: String, and password: String, completion: @escaping UserServiceCompletion) {
        networkManager.request(with: AuthorizationRequest.loginUsername(username: username, password: password)) { data, _, error in
            
            guard error == nil else {
                completion(.failure(NetworkError.connectionFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataAvailable))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                // registration failed
                if let jsonData = jsonData, jsonData["detail"] != nil {
                    completion(.success(jsonData))
                    return
                }
                
                let session = Mapper<Session>().map(JSONObject: jsonData)
                self.session = session
                completion(.success(jsonData))
            } catch {
                completion(.failure(APIError.canNotProcessData))
            }
        }
    }
    
    func registration(email: String, username: String, password: String, completion: @escaping UserServiceCompletion) {
        networkManager.request(with: AuthorizationRequest.userCreate(email: email, password: password, username: username)) { data, response, error in
            
            guard error == nil else {
                completion(.failure(NetworkError.connectionFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataAvailable))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                // registration failed
                if let jsonData = jsonData, jsonData["detail"] != nil {
                    completion(.success(jsonData))
                    return
                }
                
                let user = Mapper<User>().map(JSONObject: jsonData)
                self.user = user
                completion(.success(jsonData))
            } catch {
                completion(.failure(APIError.canNotProcessData))
            }
        }
    }
    
    func requestPasswordReset(email: String, completion: @escaping UserServiceCompletion) {
        
    }
    
    func resetPassword(code: String, newPassword: String, confirmPasword: String, email: String, completion: @escaping UserServiceCompletion) {
        
    }
    
    func updateUsername(id: String, newUsername: String, completion: @escaping UserServiceCompletion) {
        
    }
    
    func updateEmail(id: String, newEmail: String, completion: @escaping UserServiceCompletion) {
        
    }
    
    func updatePassword(oldPassword: String, newPassword: String, repeatPassword: String, completion: @escaping UserServiceCompletion) {
        
    }
    
    func delete(id: String, completion: @escaping UserServiceCompletion) {
        
    }
    
}

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}
