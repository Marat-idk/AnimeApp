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
    
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
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
}

// MARK: - HomeNavigationDelegate
extension HomeCoordinator: HomeNavigationDelegate {
    func onSelectedAnime(_ anime: Anime) {
        // FIXME: - it just mock pushing
        let vc = ModuleFactory().createAnimeDetailModule(with: anime)
        navigationController.pushViewController(vc, animated: true)
    }
}
