//
//  Anime.swift
//  AnimeApp
//
//  Created by Марат on 14.08.2023.
//

import Foundation
import ObjectMapper

// MARK: - Animes
struct Animes: Mappable {
    var pagination: Pagination?
    var data: [Anime]?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        pagination <- map["pagination"]
        data <- map["data"]
    }
    
}

// MARK: - Rating
enum Rating: String {
    case g
    case pg
    case pg13
    case r17
    case r
    case rx
    
    init?(rawValue: String) {
        switch rawValue {
        case  "g", "G - All Ages":
            self = .g
        case "pg", "PG - Children":
            self = .pg
        case "pg13", "PG-13 - Teens 13 or older":
            self = .pg13
        case "r17", "R - 17+ (violence & profanity)":
            self = .r17
        case "r", "R+ - Mild Nudity":
            self = .r
        case "rx", "Rx - Hentai":
            self = .rx
        default:
            return nil
        }
    }
    
    var description: String {
        switch self {
        case .g:
            return "G - All Ages"
        case .pg:
            return "PG - Children"
        case .pg13:
            return "PG-13 - Teens 13 or older"
        case .r17:
            return "R - 17+ (violence & profanity)"
        case .r:
            return "R+ - Mild Nudity"
        case .rx:
            return "Rx - Hentai"
        }
    }
}

// MARK: - Anime
struct Anime: Mappable {
    var malID: Int?
    var url: String?
    var images: Images?
    var trailer: Trailer?
    var approved: Bool?
    var title: String?
    var titleEnglish: String?
    var titleJapanese: String?
    var type: String?
    var source: String?
    var episodes: Int?
    var status: String?
    var airing: Bool?
    var aired: Aired?
    var duration: String?
    var rating: Rating?
    var score: Double = 0.0
    var scoredBy: Int?
    var rank: Int?
    var popularity: Int?
    var members: Int?
    var favorites: Int?
    var synopsis: String?
    var background: String?
    var season: String?
    var year: Int?
    var broadcast: Broadcast?
    var studios: [Genre]?
    var genres: [Genre]?
    var explicitGenres: [Genre]?
    var demographics: [Genre]?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        malID           <- map["mal_id"]
        url             <- map["url"]
        images          <- map["images.jpg"]
        trailer         <- map["trailer"]
        approved        <- map["approved"]
        title           <- map["title"]
        titleEnglish    <- map["title_english"]
        titleJapanese   <- map["title_japanese"]
        type            <- map["type"]
        source          <- map["source"]
        episodes        <- map["episodes"]
        status          <- map["status"]
        airing          <- map["airing"]
        aired           <- map["aired"]
        duration        <- map["duration"]
        score           <- map["score"]
        scoredBy        <- map["scored_by"]
        rank            <- map["rank"]
        popularity      <- map["popularity"]
        members         <- map["members"]
        favorites       <- map["favorites"]
        synopsis        <- map["synopsis"]
        background      <- map["background"]
        season          <- map["season"]
        year            <- map["year"]
        broadcast       <- map["broadcast"]
        studios         <- map["studios"]
        genres          <- map["genres"]
        explicitGenres  <- map["explicit_genres"]
        demographics    <- map["demographics"]
        
        var rawRating: String?
        rawRating       <- map["rating"]
        rating = Rating(rawValue: rawRating ?? "")
    }
}

// MARK: - Images
struct Images: Mappable {
    var imageURL: String?
    var smallImageURL: String?
    var largeImageURL: String?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        imageURL <- map["image_url"]
        smallImageURL <- map["small_image_url"]
        largeImageURL <- map["large_image_url"]
    }
}

// MARK: - Trailer
struct Trailer: Mappable {
    var youtubeID: String?
    var url: String?
    var embedURL: String?
    var images: TrailerImages?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        youtubeID <- map["youtube_id"]
        url <- map["url"]
        embedURL <- map["embed_url"]
        images <- map["images"]
    }
}

// MARK: - TrailerImages
struct TrailerImages: Mappable {
    var smallImageURL: String?
    var mediumImageURL: String?
    var largeImageURL: String?
    var maximumImageURL: String?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        smallImageURL <- map["small_image_url"]
        mediumImageURL <- map["medium_image_url"]
        largeImageURL <- map["large_image_url"]
        maximumImageURL <- map["maximum_image_url"]
    }
}

// MARK: - Aired
struct Aired: Mappable {
    var fromDate: String?
    var toDate: String?
    var from: DateComponents?
    var to: DateComponents?
    var formattedDateRange: String?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        fromDate <- map["from"]
        toDate <- map["to"]
        
        var rawDay: Int?
        var rawMonth: Int?
        var rawYear: Int?
        
        rawDay <- map["prop.from.day"]
        rawMonth <- map["prop.from.month"]
        rawYear <- map["prop.from.year"]
        
        if let day = rawDay,
           let month = rawMonth,
           let year = rawYear {
            
            from = DateComponents()
            from?.day = day
            from?.month = month
            from?.year = year
        }
        
        rawDay <- map["prop.to.day"]
        rawMonth <- map["prop.to.month"]
        rawYear <- map["prop.to.year"]
        
        if let day = rawDay,
           let month = rawMonth,
           let year = rawYear {
            
            to = DateComponents()
            to?.day = day
            to?.month = month
            to?.year = year
        }
        
        formattedDateRange <- map["string"]
    }
}

// MARK: - Broadcast
struct Broadcast: Mappable {
    var day: String?
    var time: String?
    var timezone: String?
    var timeDescription: String?
    
    init?(map: Map) {
        guard map.mappingType == .toJSON else { return }
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        day             <- map["day"]
        time            <- map["time"]
        timezone        <- map["timezone"]
        timeDescription <- map["string"]
    }
}
