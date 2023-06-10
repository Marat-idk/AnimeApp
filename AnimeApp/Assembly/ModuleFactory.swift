//
//  ModuleFactory.swift
//  AnimeApp
//
//  Created by Marat on 21.05.2023.
//

import UIKit

// MARK: - ModuleFactoryProtocol
protocol ModuleFactoryProtocol {
    static func createMainTabBarModule() -> UIViewController
    static func createAuthorizationModule() -> UIViewController
    // MARK: - personal menu
    static func createPesonalMenuModule(navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController
}

extension ModuleFactoryProtocol {
    static func createPesonalMenuModule() -> UIViewController {
        return createPesonalMenuModule(navigationDelegate: nil)
    }
}

// MARK: - ModuleBuilder
struct ModuleFactory: ModuleFactoryProtocol {
    
    static func createMainTabBarModule() -> UIViewController {
        return MainTabBarController()
    }
    
    static func createAuthorizationModule() -> UIViewController {
        let view = AuthorizationViewController()
        let presenter = AuthorizationPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func createPesonalMenuModule(navigationDelegate: PersonalMenuNavigationDelegate?) -> UIViewController {
        let view = PersonalMenuViewController()
        let presenter = PersonalMenuPresenter(view: view, navigationDelegate: navigationDelegate)
        view.presenter = presenter
        return view
    }
    
    static func createPrivacyPolicyModule() -> UIViewController {
        let view = PrivacyPolicyViewController()
        return view
    }
}
