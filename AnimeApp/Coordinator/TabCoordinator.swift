//
//  TabCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 19.07.2023.
//

import UIKit

// MARK: - TabBarPage
enum TabBarPage: Int {
    case home
    case search
    case download
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .download:
            return "Favorites"
        case .profile:
            return "Profile"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home:
            return .home
        case .search:
            return .search
        case .download:
            return .heart
        case .profile:
            return .personal
        }
    }
}

// MARK: - TabCoordinator
class TabCoordinator: CoordinatorProtocol {
    private let animeService: AnimeServiceProtocol
    private let userService: UserServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    private let tabBarController: UITabBarController
    // MARK: - public properties
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController,
         animeService: AnimeServiceProtocol,
         userService: UserServiceProtocol,
         favoritesService: FavoritesServiceProtocol) {
        self.navigationController = navigationController
        self.tabBarController = MainTabBarController()
        
        self.animeService = animeService
        self.userService = userService
        self.favoritesService = favoritesService
    }
    
    func start() {
        let pages: [TabBarPage] = [.home, .search, .download, .profile]
        
        let controllers = pages.map { generateVC(for: $0) }
        
        prepareTabBar(with: controllers)
    }
    
    private func generateVC(for page: TabBarPage) -> UIViewController {
        let navigationController = UINavigationController()
        
        let tabBarItem = UITabBarItem(title: page.title, image: page.image, selectedImage: nil)
        navigationController.tabBarItem = tabBarItem
        
        switch page {
        case .home:
            let homeCoordinator = CoordinatorFactory.createHomeCoordinator(with: navigationController,
                                                                           favoritesService: favoritesService)
            childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .search:
            let searchCoordinator = CoordinatorFactory.createSearchCoordinator(with: navigationController,
                                                                               animeService: animeService,
                                                                               favoritesService: favoritesService)
            childCoordinators.append(searchCoordinator)
            searchCoordinator.start()
        case .download:
            let favoritesCoordinator = CoordinatorFactory.createFavoritesCoordinator(with: navigationController,
                                                                     animeService: animeService,
                                                                     favoritesService: favoritesService)
            childCoordinators.append(favoritesCoordinator)
            favoritesCoordinator.start()
        case .profile:
            let profileCoordinator = CoordinatorFactory.createPersonalMenuCoordinator(with: navigationController)
            childCoordinators.append(profileCoordinator)
            profileCoordinator.start()
        }
        return navigationController
    }
    
    private func prepareTabBar(with controllers: [UIViewController]) {
        tabBarController.viewControllers = controllers
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}
