//
//  Array+Helper.swift
//  AnimeApp
//
//  Created by Марат on 20.08.2023.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
