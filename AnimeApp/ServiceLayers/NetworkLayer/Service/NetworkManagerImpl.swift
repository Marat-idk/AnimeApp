//
//  NetworkManagerImpl.swift
//  AnimeApp
//
//  Created by Marat on 16.04.2023.
//

import Foundation

// MARK: - NetworkManagerImpl
struct NetworkManagerImpl: NetworkManager {
    private var task: URLSessionDataTask?
    
    mutating func request(with request: RequestProtocol, completion: @escaping NetworkManagerCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try buildRequest(with: request)
            
            task = session.dataTask(with: request) { data, response, error in
                completion(data, response, error)
            }
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func buildRequest(with requestProtocol: RequestProtocol) throws -> URLRequest {
        
        guard let url = URL(string: requestProtocol.baseURL + requestProtocol.path) else { throw NetworkError.missingURL }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = requestProtocol.httpMethod.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = requestProtocol.parameters {
            try URLParameterEncoder.encode(urlRequest: &request, with: parameters)
        }
        
        if let headers = requestProtocol.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = requestProtocol.body {
            let bodyData = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            request.httpBody = bodyData
        }
        
        return request
    }
}
