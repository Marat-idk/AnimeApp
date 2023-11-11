//
//  FavoritesService.swift
//  AnimeApp
//
//  Created by Марат on 06.11.2023.
//

import Foundation
import RealmSwift

// MARK: - FavoritesServiceProtocol
protocol FavoritesServiceProtocol {
    var favoriteAnimes: [Anime] { get }
    
    func append(_ anime: Anime)
    func remove(_ anime: Anime)
    func removeAll()
    func exists(_ anime: Anime) -> Bool
}

// MARK: - FavoritesService
struct FavoritesService: FavoritesServiceProtocol {
    private let realm = try? Realm()
    
    var favoriteAnimes: [Anime] {
        return realm?.objects(DBAnime.self).map { Anime($0) } ?? []
    }
    
    func append(_ anime: Anime) {
        guard let realm = realm else {
            return
        }
        
        if exists(anime) {
            remove(anime)
        }
        
        let dbAnime = DBAnime(mallId: anime.malID,
                            image: anime.images?.largeImageURL,
                            title: anime.title,
                            duration: anime.duration,
                            score: anime.score,
                              synopsis: anime.synopsis)
        
        try? realm.write {
            realm.add(dbAnime)
        }
    }
    
    func remove(_ anime: Anime) {
        guard let realm = realm,
              let anime = realm.object(ofType: DBAnime.self, forPrimaryKey: anime.malID) else { return }
        
        try? realm.write {
            realm.delete(anime)
        }
    }
    
    func removeAll() {
        guard let realm = realm else { return }
        
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    func exists(_ anime: Anime) -> Bool {
        return realm?.object(ofType: DBAnime.self, forPrimaryKey: anime.malID) != nil
    }
}

// MARK: - Anime init
fileprivate extension Anime {
    init(_ dbAnime: DBAnime) {
        self.malID = dbAnime.mallId
        self.title = dbAnime.title
        self.duration = dbAnime.duration
        self.score = dbAnime.score
        self.images = Images(dbAnime.image)
        self.synopsis = dbAnime.synopsis
    }
}

// MARK: - Images init
fileprivate extension Images {
    init(_ imageURL: String?) {
        self.imageURL = imageURL
        self.smallImageURL = imageURL
        self.largeImageURL = imageURL
    }
}
