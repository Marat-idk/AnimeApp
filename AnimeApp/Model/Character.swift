//
//  Character.swift
//  AnimeApp
//
//  Created by Марат on 03.09.2023.
//

import Foundation
import ObjectMapper

// MARK: - Characters
typealias Characters = [Character]

// MARK: - Character
struct Character: Mappable {
    var malID: Int?
    var name: String?
    var url: String?
    var images: Images?
    var role: String?
    var favorites: Int?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        malID     <- map["character.mal_id"]
        name      <- map["character.name"]
        url       <- map["character.url"]
        images    <- map["character.images.jpg"]
        images    <- map["character.role"]
        favorites <- map["favorites"]
    }
}
