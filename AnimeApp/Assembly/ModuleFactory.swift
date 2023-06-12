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
    // MARK: - personal menu
    func createPesonalMenuModule(navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController
    func createNotificationModule() -> UIViewController
    func createLanguageModule() -> UIViewController
    func createPrivacyPolicyModule() -> UIViewController
}

extension ModuleFactoryProtocol {
    func createPesonalMenuModule() -> UIViewController {
        return createPesonalMenuModule(navigationDelegate: nil)
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
    
    func createPesonalMenuModule(navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController {
        let view = PersonalMenuViewController()
        let presenter = PersonalMenuPresenter(view: view, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    func createNotificationModule() -> UIViewController {
        let view = NotificationViewController()
        return view
    }
    
    func createLanguageModule() -> UIViewController {
        let view = LanguageViewController()
        return view
    }
    
    func createPrivacyPolicyModule() -> UIViewController {
        let view = PrivacyPolicyViewController()
        return view
    }
}
