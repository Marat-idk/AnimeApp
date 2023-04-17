//
//  NetworkError.swift
//  AnimeApp
//
//  Created by Marat on 16.04.2023.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: String, Error {
    case connectionFailed   = "Connection failed"
    case parametersNil      = "Parameters are nil"
    case encodingFailed     = "Encoding was failed"
    case missingURL         = "URL is nil"
}
