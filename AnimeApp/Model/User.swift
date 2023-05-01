//
//  User.swift
//  AnimeApp
//
//  Created by Marat on 19.04.2023.
//

import Foundation
import ObjectMapper

// MARK: - User
struct User: Mappable {
    var id: String?
    var username: String?
    var email: String?
    var created: String?
    var updated: String?
    var verified: Bool?
    var verificationDate: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["account.id"]
        username <- map["account.username"]
        email <- map["account.email"]
        created <- map["account.created"]
        updated <- map["account.updated"]
        verified <- map["account.verified"]
        verificationDate <- map["account.verification_date"]
    }
}
