//
//  SearchCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 29.10.2023.
//

import UIKit

// MARK: - SearchCoordinator
final class SearchCoordinator: CoordinatorProtocol {
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
        showSearch()
    }
    
    func showSearch() {
        let view = moduleFactory.createSearch(animeService: animeService, navigationDelegate: self)
        navigationController.pushViewController(view, animated: true)
    }
}

// MARK: - SearchNavigationDelegate
extension SearchCoordinator: SearchNavigationDelegate {
    func onSelectedAnime(_ anime: Anime) {
        let view = moduleFactory.createAnimeDetailModule(with: anime,
                                                         animeService: animeService,
                                                         favoritesService: favoritesService)
        navigationController.pushViewController(view, animated: true)
    }

}
