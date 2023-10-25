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
    func createHomeModule(userService: UserServiceProtocol, animeService: AnimeServiceProtocol, navigationDelegate: HomeNavigationDelegate?) -> UIViewController
    func createAnimeDetailModule(with anime: Anime) -> UIViewController
    func createAnimesModule(animeService: AnimeServiceProtocol, with searchOptions: AnimeSearchOptions) -> UIViewController
    // MARK: - personal menu
    func createPesonalMenuModule(navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController
    func createEditProfileModule(userService: UserServiceProtocol, editProfileDelegate: EditProfileDelegate?) -> UIViewController
    func createNotificationModule() -> UIViewController
    func createLanguageModule(languageDelegate: LanguageUpdatingDelegate?) -> UIViewController
    func createPrivacyPolicyModule() -> UIViewController
}

// MARK: - default implementation
extension ModuleFactoryProtocol {
    func createHomeModule(userService: UserServiceProtocol, animeService: AnimeServiceProtocol) -> UIViewController {
        return createHomeModule(userService: userService, animeService: animeService, navigationDelegate: nil)
    }
    
    func createPesonalMenuModule() -> UIViewController {
        return createPesonalMenuModule(navigationDelegate: nil)
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
    func createHomeModule(userService: UserServiceProtocol, animeService: AnimeServiceProtocol, navigationDelegate: HomeNavigationDelegate?) -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter(view: view,
                                      userService: userService,
                                      animeService: animeService,
                                      navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    func createAnimeDetailModule(with anime: Anime) -> UIViewController {
        let view = AnimeDetailViewController()
        let presenter = AnimeDetailPresenter(view: view, anime: anime)
        view.presenter = presenter
        return view
    }
    
    func createAnimesModule(animeService: AnimeServiceProtocol, with searchOptions: AnimeSearchOptions) -> UIViewController {
        let view = AnimesViewController()
        let presenter = AnimesPresenter(view: view, animeService: animeService, searchOptions: searchOptions)
        view.presenter = presenter
        return view
    }
    
    // MARK: personal menu
    func createPesonalMenuModule(navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController {
        let view = PersonalMenuViewController()
        let presenter = PersonalMenuPresenter(view: view, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    func createEditProfileModule(userService: UserServiceProtocol, editProfileDelegate: EditProfileDelegate?) -> UIViewController {
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
