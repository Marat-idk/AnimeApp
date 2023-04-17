//
//  NetworkManager.swift
//  AnimeApp
//
//  Created by Marat on 16.04.2023.
//

import Foundation

// MARK: - NetworkRouterCompletion
typealias NetworkManagerCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

// MARK: - NetworkManager
protocol NetworkManager {
    mutating func request(with request: RequestProtocol, completion: @escaping NetworkManagerCompletion)
    func cancel()
}
