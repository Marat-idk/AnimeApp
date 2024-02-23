//
//  CoordinatorFactory.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    static func createHomeCoordinator(with navigationController: UINavigationController, favoritesService: FavoritesServiceProtocol) -> HomeCoordinator
    
    static func animesCoordinator(with navigationController: UINavigationController, searchOptions: AnimeSearchOptions, favoritesService: FavoritesServiceProtocol) -> AnimesCoordinator
    
    static func createSearchCoordinator(with navigationController: UINavigationController, animeService: AnimeServiceProtocol, favoritesService: FavoritesServiceProtocol) -> SearchCoordinator
    
    static func createFavoritesCoordinator(with navigationController: UINavigationController, animeService: AnimeServiceProtocol, favoritesService: FavoritesServiceProtocol) -> FavoritesCoordinator
    
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController, appDependency: HasDependencies) -> PersonalMenuCoordinator
    
    static func createLanguageCoordinator(with navigationController: UINavigationController) -> LanguageCoordinator
    
    static func createEditProfileCoordinator(with navigationController: UINavigationController) -> EditProfileCoordinator
}

struct CoordinatorFactory: CoordinatorFactoryProtocol {
    static func createHomeCoordinator(with navigationController: UINavigationController,
                                      favoritesService: FavoritesServiceProtocol) -> HomeCoordinator {
        
        return HomeCoordinator(navigationController: navigationController, favoritesService: favoritesService)
    }
    
    static func animesCoordinator(with navigationController: UINavigationController, searchOptions: AnimeSearchOptions, favoritesService: FavoritesServiceProtocol) -> AnimesCoordinator {
        
        return AnimesCoordinator(navigationController: navigationController,
                                 favoritesService: favoritesService,
                                 animeSearchOptions: searchOptions)
    }
    
    static func createSearchCoordinator(with navigationController: UINavigationController, animeService: AnimeServiceProtocol, favoritesService: FavoritesServiceProtocol) -> SearchCoordinator {
        
        return SearchCoordinator(navigationController: navigationController,
                                 animeService: animeService,
                                 favoritesService: favoritesService)
    }
    
    static func createFavoritesCoordinator(with navigationController: UINavigationController, animeService: AnimeServiceProtocol, favoritesService: FavoritesServiceProtocol) -> FavoritesCoordinator {
        
        return FavoritesCoordinator(navigationController: navigationController,
                                    animeService: animeService,
                                    favoritesService: favoritesService)
    }
    
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController, appDependency: HasDependencies) -> PersonalMenuCoordinator {
        return PersonalMenuCoordinator(navigationController: navigationController, appDependency: appDependency)
    }
    
    static func createLanguageCoordinator(with navigationController: UINavigationController) -> LanguageCoordinator {
        return LanguageCoordinator(navigationController: navigationController)
    }
    
    static func createEditProfileCoordinator(with navigationController: UINavigationController) -> EditProfileCoordinator {
        return EditProfileCoordinator(navigationController: navigationController)
    }
}
