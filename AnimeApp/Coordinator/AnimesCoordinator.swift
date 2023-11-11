//
//  AnimesCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 12.11.2023.
//

import UIKit

final class AnimesCoordinator: CoordinatorProtocol {
    private let moduleFactory: ModuleFactoryProtocol
    private let animeService: AnimeServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private let animeSearchOptions: AnimeSearchOptions
    
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController,
         moduleFactory: ModuleFactoryProtocol = ModuleFactory(),
         animeService: AnimeServiceProtocol = AnimeService.shared,
         favoritesService: FavoritesServiceProtocol,
         animeSearchOptions: AnimeSearchOptions) {
        
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.animeService = animeService
        self.favoritesService = favoritesService
        self.animeSearchOptions = animeSearchOptions
    }
    
    func start() {
        showAnimes()
    }
    
    func showAnimes() {
        let view = moduleFactory.createAnimesModule(animeService: animeService,
                                                    with: animeSearchOptions,
                                                    navigationDelegate: self)
        
        if var view = view as? FlowCoordinator {
            view.completionHandler = { [weak self] _ in
                self?.finish()
            }
        }
        
        navigationController.pushViewController(view, animated: true)
    }
}

// MARK: - AnimesNavigationDelegate
extension AnimesCoordinator: AnimesNavigationDelegate {
    func onSelectedAnime(_ anime: Anime) {
        let view = moduleFactory.createAnimeDetailModule(with: anime, favoritesService: favoritesService)
        navigationController.pushViewController(view, animated: true)
    }
    
}
