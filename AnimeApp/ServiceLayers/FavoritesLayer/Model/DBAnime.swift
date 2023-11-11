//
//  DBAnime.swift
//  AnimeApp
//
//  Created by Марат on 10.11.2023.
//

import Foundation
import RealmSwift

// MARK: - DBAnime
final class DBAnime: Object {
    @objc dynamic var mallId: Int = 0
    @objc dynamic var image: String?
    @objc dynamic var title: String?
    @objc dynamic var duration: String?
    @objc dynamic var score: Double = 0
    @objc dynamic var synopsis: String?
    
    override static func primaryKey() -> String? {
      return "mallId"
    }
    
    convenience init(mallId: Int,
                     image: String? = nil,
                     title: String? = nil,
                     duration: String? = nil,
                     score: Double,
                     synopsis: String?) {
        self.init()
        self.mallId = mallId
        self.image = image
        self.title = title
        self.duration = duration
        self.score = score
        self.synopsis = synopsis
    }
}
