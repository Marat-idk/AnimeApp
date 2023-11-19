//
//  HomeCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 05.09.2023.
//

import UIKit

// MARK: HomeCoordinator
class HomeCoordinator: CoordinatorProtocol {
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
        showHome()
    }
    
    func showHome() {
        let view = moduleFactory.createHomeModule(userService: UserService.shared,
                                                  animeService: AnimeService.shared,
                                                  navigationDelegate: self)
        navigationController.pushViewController(view, animated: false)
    }
    
    func showAnimeDetail(for anime: Anime) {
        let view = moduleFactory.createAnimeDetailModule(with: anime,
                                                         animeService: animeService,
                                                         favoritesService: favoritesService)
        navigationController.pushViewController(view, animated: true)
    }
    
    func showMostPopularAnimes(with searchOptions: AnimeSearchOptions) {
        let animesFlow = CoordinatorFactory.animesCoordinator(with: navigationController,
                                                              searchOptions: searchOptions,
                                                              favoritesService: favoritesService)
        
        animesFlow.flowCompletionHandler = {
            print("animesFlow ended")
        }
        
        animesFlow.start()
        childCoordinators.append(animesFlow)
    }
}

// MARK: - HomeNavigationDelegate
extension HomeCoordinator: HomeNavigationDelegate {
    func onSelectedAnime(_ anime: Anime) {
        showAnimeDetail(for: anime)
    }
    
    func onSelectedMostPopularGenre(with searchOptions: AnimeSearchOptions) {
        showMostPopularAnimes(with: searchOptions)
    }
}
