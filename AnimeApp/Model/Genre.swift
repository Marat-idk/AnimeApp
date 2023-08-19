//
//  Genre.swift
//  AnimeApp
//
//  Created by Marat on 09.05.2023.
//

import Foundation
import ObjectMapper

enum ContentType: String {
    case anime
    case manga
    
    init?(rawValue: String) {
        switch rawValue {
        case "anime":
            self = .anime
        case "manga":
            self = .manga
        default:
            return nil
        }
    }
}

// MARK: - Genre
struct Genre: Mappable {
    var malID: Int?
    var type: ContentType?
    var name: String?
    var url: String?
    var count: Int?
    var isSelected: Bool? = false
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    init(malID: Int, type: ContentType, name: String, url: String, count: Int, isSelected: Bool? = nil) {
        self.malID = malID
        self.type = type
        self.name = name
        self.url = url
        self.count = count
        self.isSelected = isSelected
    }
    
    mutating func mapping(map: Map) {
        malID   <- map["mal_id"]
        name    <- map["name"]
        url     <- map["url"]
        count   <- map["count"]
        
        var typeRawValue = ""
        
        typeRawValue <- map["type"]
        
        type = ContentType(rawValue: typeRawValue)
    }
    
    // TODO: - hardcoded, should remove it maybe
    static func topGenres() -> [Genre] {
        return [
            Genre(malID: -1, type: .anime, name: "All", url: "", count: -1, isSelected: true),
            Genre(malID: 27, type: .anime, name: "Shounen", url: "https://myanimelist.net/anime/genre/27/Shounen", count: 1881),
            Genre(malID: 4, type: .anime, name: "Comedy", url: "https://myanimelist.net/anime/genre/4/Comedy", count: 7156),
            Genre(malID: 1, type: .anime, name: "Action", url: "https://myanimelist.net/anime/genre/1/Action", count: 4747),
            Genre(malID: 24, type: .anime, name: "Sci-Fi", url: "https://myanimelist.net/anime/genre/24/Sci-Fi", count: 3109)
        ]
    }
}

// MARK: - Equatable
extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.malID == rhs.malID
    }
}
