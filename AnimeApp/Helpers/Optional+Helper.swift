//
//  Optional+Helper.swift
//  AnimeApp
//
//  Created by Марат on 27.09.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self == nil || self?.isEmpty == true
    }
}
