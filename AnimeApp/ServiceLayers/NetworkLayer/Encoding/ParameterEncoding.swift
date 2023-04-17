//
//  ParameterEncoding.swift
//  AnimeApp
//
//  Created by Marat on 16.04.2023.
//

import Foundation

// MARK: - ParameterEncoder
protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
