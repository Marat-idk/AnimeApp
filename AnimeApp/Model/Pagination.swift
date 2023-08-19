//
//  Pagination.swift
//  AnimeApp
//
//  Created by Марат on 14.08.2023.
//

import Foundation
import ObjectMapper

// MARK: - Pagination
struct Pagination: Mappable {
    var lastVisiblePage: Int?
    var hasNextPage: Bool?
    var currentPage: Int?
    var items: Items?
    
    init() {}
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        lastVisiblePage <- map["last_visible_page"]
        hasNextPage <- map["has_next_page"]
        currentPage <- map["current_page"]
        items <- map["items"]
    }
}

// MARK: - Items
struct Items: Mappable {
    var count: Int?
    var total: Int?
    var perPage: Int?
    
    init() {}
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        count <- map["count"]
        total <- map["total"]
        perPage <- map["per_page"]
    }
}
