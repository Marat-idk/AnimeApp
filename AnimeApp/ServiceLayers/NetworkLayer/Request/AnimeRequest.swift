//
//  AnimeRequest.swift
//  AnimeApp
//
//  Created by Marat on 09.05.2023.
//

import Foundation

// MARK: - AnimeSearchOptions
typealias AnimeSearchOptions = AnimeRequest.AnimeSearchOptions

// MARK: - GenresFilter
enum GenresFilter: String {
    case genres
    case explicitGenres = "explicit_genres"
    case themes
    case demographics
}

enum OrderBy {
    case malID
    case title
    case startDate
    case endDate
    case episodes
    case score
    case scoredBy
    case rank
    case popularity
    case members
    case favorites
    
    var rawValue: String {
        switch self {
        case .malID:      return "mal_id"
        case .title:      return "title"
        case .startDate:  return "start_date"
        case .endDate:    return "end_date"
        case .episodes:   return "episodes"
        case .score:      return "score"
        case .scoredBy:   return "scored_by"
        case .rank:       return "rank"
        case .popularity: return "popularity"
        case .members:    return "members"
        case .favorites:  return "favorites"
        }
    }
}

enum SortOrderType: String {
    case asc
    case desc
}

// MARK: - AnimeRequest
enum AnimeRequest {
    case animeGenres(_ filter: GenresFilter? = nil)
    case mangaGenres(_ filter: GenresFilter? = nil)
    case animeSearch(_ searchOptions: AnimeSearchOptions? = nil)
    
    case animeCharacters(_ animeId: Int)
    
    struct AnimeSearchOptions {
        var pagination: Pagination?
        var filter: Filter?
        
        struct Filter {
            var status: Status?
            var rating: Rating?
            var genres: [Int]?
            var genresExclude: [Int]?
            var orderBy: OrderBy?
            var sortOrder: SortOrderType?
            var query: String?
        }
        
        init() {
            self.pagination = Pagination()
            self.filter = Filter()
            
            self.pagination?.items = Items()
        }
    }
}

// MARK: - RequestProtocol
extension AnimeRequest: RequestProtocol {
    var baseURL: String {
        return "https://api.jikan.moe/v4/"
    }
    
    var path: String {
        switch self {
        case .animeGenres:
            return "genres/anime"
        case .mangaGenres:
            return "genres/manga"
        case .animeSearch:
            return "anime"
        case .animeCharacters(let id):
            return "anime/\(id)/characters"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .animeGenres(let filter):
            return filter != nil ? ["filter": filter!.rawValue] : nil
        case .mangaGenres(let filter):
            return filter != nil ? ["filter": filter!.rawValue] : nil
        case .animeSearch(let model):
            guard let model = model else { return nil }
            
            var params: [String: Any] = [:]
            
            if let page = model.pagination?.currentPage {
                params["page"] = page
            }
            
            if let perPage = model.pagination?.items?.perPage {
                params["limit"] = perPage
            }
            
            if let status = model.filter?.status {
                params["status"] = status.rawValue
            }
            
            if let rating = model.filter?.rating {
                params["rating"] = rating.rawValue
            }
            
            if let orderBy = model.filter?.orderBy {
                params["order_by"] = orderBy.rawValue
            }
            
            if let sortOrder = model.filter?.sortOrder {
                params["sort"] = sortOrder.rawValue
            }
            
            if let genres = model.filter?.genres {
                params["genres"] = genres.map { String($0) }.joined(separator: ",")
            }
            
//            params["type"] = "movie"
            
            if let query = model.filter?.query {
                params["q"] = query
            }
            
            return params
        default:
            return nil
        }
    }
}
