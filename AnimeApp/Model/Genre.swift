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
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        malID <- map["mal_id"]
        name <- map["name"]
        url <- map["url"]
        count <- map["count"]
    }
}
