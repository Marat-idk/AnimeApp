//
//  FavoritesCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 11.11.2023.
//

import UIKit

// MARK: - FavoritesCoordinator
final class FavoritesCoordinator: CoordinatorProtocol {
    private let moduleFactory: ModuleFactoryProtocol
    private let animeService: AnimeServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController,
         moduleFactory: ModuleFactoryProtocol = ModuleFactory(),
         animeService: AnimeServiceProtocol = AnimeService.shared,
         favoritesService: FavoritesServiceProtocol) {
        
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.animeService = animeService
        self.favoritesService = favoritesService
    }
    
    func start() {
        showFavorites()
    }
    
    func showFavorites() {
        let view = moduleFactory.createFavorites(favoriteService: favoritesService, navigationDelegate: self)
        navigationController.pushViewController(view, animated: true)
    }
}

extension FavoritesCoordinator: FavoritesNavigationDelegate {
    func onSelectedAnime(_ anime: Anime) {
        let view = moduleFactory.createAnimeDetailModule(with: anime,
                                                         animeService: animeService,
                                                         favoritesService: favoritesService)
        navigationController.pushViewController(view, animated: true)
    }
}
