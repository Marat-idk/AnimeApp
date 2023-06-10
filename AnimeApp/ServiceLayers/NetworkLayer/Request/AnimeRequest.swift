//
//  AnimeRequest.swift
//  AnimeApp
//
//  Created by Marat on 09.05.2023.
//

import Foundation

// MARK: - GenresFilter
enum GenresFilter: String {
    case genres
    case explicitGenres = "explicit_genres"
    case themes
    case demographics
}

// MARK: - AnimeRequest
enum AnimeRequest {
    case getAnimeGenres(_ filter: GenresFilter? = nil)
    case getMangaGenres(_ filter: GenresFilter? = nil)
}

extension AnimeRequest: RequestProtocol {
    var baseURL: String {
        return "https://api.jikan.moe/v4/"
    }
    
    var path: String {
        switch self {
        case .getAnimeGenres:
            return "genres/anime"
        case .getMangaGenres:
            return "genres/manga"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAnimeGenres(let filter):
            return filter != nil ? ["filter": filter!.rawValue] : nil
        case .getMangaGenres(let filter):
            return filter != nil ? ["filter": filter!.rawValue] : nil
        }
    }
}
