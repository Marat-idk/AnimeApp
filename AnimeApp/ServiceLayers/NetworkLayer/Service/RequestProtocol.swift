//
//  RequestProtocol.swift
//  AnimeApp
//
//  Created by Marat on 16.04.2023.
//

import Foundation

// MARK: - Parameters
typealias Parameters = [String: Any]

//MARK: - HTTPHeaders
typealias HTTPHeaders = [String: String]

// MARK: - HTTPBody
typealias HTTPBody = [String: Any]

// MARK: - RequestProtocol
protocol RequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var body: HTTPBody? { get }
}

extension RequestProtocol {
    var parameters: Parameters? { nil }
    var headers: HTTPHeaders? { return nil }
    var body: HTTPBody? { return nil }
    
    var descriptionString: String {
        let urlComponents = NSURLComponents()
        if let parameters = parameters, !parameters.isEmpty {
            urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        }

        let query =  urlComponents.query != nil ? "?\(urlComponents.query!)" : ""

        var log = "curl -X '\(httpMethod)' \\\n \(baseURL)\(path)\(query) \\\n"
        if let headers = headers {
            for (key, value) in headers {
                log += "-H '\(key): \(value)' \\\n"
            }
        }
        if
            let data = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed),
            let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let prettyData = try? JSONSerialization.data(withJSONObject: dict, options: [.fragmentsAllowed]),
            let text = String(data: prettyData, encoding: .ascii) {

            log += "-d '\(text)'"
        }

        return log
    }
}
