//
//  Session.swift
//  AnimeApp
//
//  Created by Marat on 19.04.2023.
//

import Foundation
import ObjectMapper

// MARK: - Session
struct Session: Mappable {
    var id: String?
    var userId: String?
    var created: String?
    var expires: String?

    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {        
        id <- map["session.id"]
        userId <- map["session.userId"]
        created <- map["session.created"]
        expires <- map["session.expires"]
    }
    
}
