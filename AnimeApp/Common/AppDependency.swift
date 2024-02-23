//
//  AppDependency.swift
//  AnimeApp
//
//  Created by Марат on 24.02.2024.
//

import Foundation

// MARK: - HasDependencies
protocol HasDependencies {
    var animeService: AnimeServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var favoritesService: FavoritesServiceProtocol { get }
}

// MARK: - AppDependency
final class AppDependency: HasDependencies {
    var animeService: AnimeServiceProtocol
    var userService: UserServiceProtocol
    var favoritesService: FavoritesServiceProtocol
    
    init(animeService: AnimeServiceProtocol, userService: UserServiceProtocol, favoritesService: FavoritesServiceProtocol) {
        self.animeService = animeService
        self.userService = userService
        self.favoritesService = favoritesService
    }
    
    static func makeDefault() -> AppDependency {
        let animeService = AnimeService.shared
        let userService = UserService.shared
        let favoritesService = FavoritesService()
        return .init(animeService: animeService, userService: userService, favoritesService: favoritesService)
    }
}
