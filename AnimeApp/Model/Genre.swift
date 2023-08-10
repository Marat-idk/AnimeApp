//
//  Genre.swift
//  AnimeApp
//
//  Created by Marat on 09.05.2023.
//

import Foundation
import ObjectMapper

// MARK: - Genre
struct Genre: Mappable {
    var malID: Int?
    var name: String?
    var url: String?
    var count: Int?
    var isSelected: Bool? = false
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    init(malID: Int, name: String, url: String, count: Int, isSelected: Bool? = nil) {
        self.malID = malID
        self.name = name
        self.url = url
        self.count = count
        self.isSelected = isSelected
    }
    
    mutating func mapping(map: Map) {
        malID <- map["mal_id"]
        name <- map["name"]
        url <- map["url"]
        count <- map["count"]
    }
    
    // TODO: - hardcoded, should remove it maybe
    static func topGenres() -> [Genre] {
        return [
            Genre(malID: -1, name: "All", url: "", count: -1, isSelected: true),
            Genre(malID: 27, name: "Shounen", url: "https://myanimelist.net/anime/genre/27/Shounen", count: 1881),
            Genre(malID: 4, name: "Comedy", url: "https://myanimelist.net/anime/genre/4/Comedy", count: 7156),
            Genre(malID: 1, name: "Action", url: "https://myanimelist.net/anime/genre/1/Action", count: 4747),
            Genre(malID: 24, name: "Sci-Fi", url: "https://myanimelist.net/anime/genre/24/Sci-Fi", count: 3109)
        ]
    }
}

// MARK: - Equatable
extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.malID == rhs.malID
    }
}
