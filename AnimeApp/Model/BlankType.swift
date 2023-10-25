//
//  BlankType.swift
//  AnimeApp
//
//  Created by Марат on 26.10.2023.
//

import UIKit

// MARK: - BlankType
enum BlankType {
    case noSearchResult
    case noFavorites
    
    var image: UIImage? {
        switch self {
        case .noSearchResult:
            return .noResults
        case .noFavorites:
            return .folder
        }
    }
    
    var title: String {
        switch self {
        case .noSearchResult:
            return "we are sorry, we can\nnot find the Anime :(".capitalized
        case .noFavorites:
            return "there is no anime yet!".capitalized
        }
    }
    
    var description: String {
        switch self {
        case .noSearchResult:
            return "Find your anime by title"
        case .noFavorites:
            return "Add anime to favorite"
        }
    }
}
