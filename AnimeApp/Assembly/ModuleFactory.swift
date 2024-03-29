//
//  ModuleFactory.swift
//  AnimeApp
//
//  Created by Marat on 21.05.2023.
//

import UIKit

// MARK: - ModuleFactoryProtocol
protocol ModuleFactoryProtocol {
    func createMainTabBarModule() -> UIViewController
    
    func createAuthorizationModule() -> UIViewController
    
    // MARK: - home
    func createHomeModule(userService: UserServiceProtocol,
                          animeService: AnimeServiceProtocol,
                          navigationDelegate: HomeNavigationDelegate?) -> UIViewController
    
    func createAnimeDetailModule(with anime: Anime,
                                 animeService: AnimeServiceProtocol,
                                 favoritesService: FavoritesServiceProtocol) -> UIViewController
    
    func createAnimesModule(animeService: AnimeServiceProtocol,
                            with searchOptions: AnimeSearchOptions,
                            navigationDelegate: AnimesNavigationDelegate) -> UIViewController
    
    // MARK: - search
    func createSearch(animeService: AnimeServiceProtocol,
                      navigationDelegate: SearchNavigationDelegate?) -> UIViewController
    
    // MARK: - favorites
    func createFavorites(favoriteService: FavoritesServiceProtocol,
                         navigationDelegate: FavoritesNavigationDelegate) -> UIViewController
    
    // MARK: - personal menu
    func createPesonalMenuModule(userService: UserServiceProtocol, navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController
    
    func createEditProfileModule(userService: UserServiceProtocol,
                                 editProfileDelegate: EditProfileDelegate?) -> UIViewController
    
    func createNotificationModule() -> UIViewController
    
    func createLanguageModule(languageDelegate: LanguageUpdatingDelegate?) -> UIViewController
    
    func createPrivacyPolicyModule() -> UIViewController
}

// MARK: - default implementation
extension ModuleFactoryProtocol {
    func createHomeModule(userService: UserServiceProtocol, animeService: AnimeServiceProtocol) -> UIViewController {
        return createHomeModule(userService: userService, animeService: animeService, navigationDelegate: nil)
    }
    
    func createSearch(animeService: AnimeServiceProtocol) -> UIViewController {
        return createSearch(animeService: animeService, navigationDelegate: nil)
    }
    
    func createPesonalMenuModule(userService: UserServiceProtocol) -> UIViewController {
        return createPesonalMenuModule(userService: userService, navigationDelegate: nil)
    }
    
    func createEditProfileModule(userService: UserServiceProtocol) -> UIViewController {
        return createEditProfileModule(userService: userService, editProfileDelegate: nil)
    }
}

// MARK: - ModuleBuilder
struct ModuleFactory: ModuleFactoryProtocol {
    
    func createMainTabBarModule() -> UIViewController {
        return MainTabBarController()
    }
    
    func createAuthorizationModule() -> UIViewController {
        let view = AuthorizationViewController()
        let presenter = AuthorizationPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    // MARK: home
    func createHomeModule(userService: UserServiceProtocol,
                          animeService: AnimeServiceProtocol,
                          navigationDelegate: HomeNavigationDelegate?) -> UIViewController {
        
        let view = HomeViewController()
        let presenter = HomePresenter(view: view,
                                      userService: userService,
                                      animeService: animeService,
                                      navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    func createAnimeDetailModule(with anime: Anime,
                                 animeService: AnimeServiceProtocol,
                                 favoritesService: FavoritesServiceProtocol) -> UIViewController {
        
        let view = AnimeDetailViewController()
        let presenter = AnimeDetailPresenter(view: view,
                                             anime: anime,
                                             animeService: animeService,
                                             favoritesService: favoritesService)
        view.presenter = presenter
        return view
    }
    
    func createAnimesModule(animeService: AnimeServiceProtocol,
                            with searchOptions: AnimeSearchOptions,
                            navigationDelegate: AnimesNavigationDelegate) -> UIViewController {
        
        let view = AnimesViewController()
        let presenter = AnimesPresenter(view: view,
                                        animeService: animeService,
                                        searchOptions: searchOptions, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    // MARK: search
    func createSearch(animeService: AnimeServiceProtocol,
                      navigationDelegate: SearchNavigationDelegate?) -> UIViewController {
        
        let view = SearchViewController()
        let presenter = SearchPresenter(view: view, animeService: animeService, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    // MARK: favorites
    func createFavorites(favoriteService: FavoritesServiceProtocol,
                         navigationDelegate: FavoritesNavigationDelegate) -> UIViewController {
        
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter(view: view, favoritesService: favoriteService, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    // MARK: personal menu
    func createPesonalMenuModule(userService: UserServiceProtocol, navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController {
        
        let view = PersonalMenuViewController()
        let presenter = PersonalMenuPresenter(view: view, userService: userService, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    func createEditProfileModule(userService: UserServiceProtocol,
                                 editProfileDelegate: EditProfileDelegate?) -> UIViewController {
        
        let view = EditProfileViewController()
        let presenter = EditProfilePresenter(view: view, userService: userService, delegate: editProfileDelegate)
        view.presenter = presenter
        return view
    }
    
    func createNotificationModule() -> UIViewController {
        let view = NotificationViewController()
        return view
    }
    
    func createLanguageModule(languageDelegate: LanguageUpdatingDelegate?) -> UIViewController {
        let view = LanguageViewController()
        let presenter = LanguagePresenter(view: view, delegate: languageDelegate)
        view.presenter = presenter
        return view
    }
    
    func createPrivacyPolicyModule() -> UIViewController {
        let view = PrivacyPolicyViewController()
        return view
    }
}
