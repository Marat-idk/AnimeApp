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
    func createEditProfileModule(editProfileDelegate: EditProfileDelegate?) -> UIViewController
    func createNotificationModule() -> UIViewController
    func createLanguageModule(languageDelegate: LanguageUpdatingDelegate?) -> UIViewController
    func createPrivacyPolicyModule() -> UIViewController
}

// MARK: - default implementation
extension ModuleFactoryProtocol {
    func createPesonalMenuModule() -> UIViewController {
        return createPesonalMenuModule(navigationDelegate: nil)
    }
    
    func createEditProfileModule() -> UIViewController {
        return createEditProfileModule(editProfileDelegate: nil)
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
    
    func createEditProfileModule(editProfileDelegate: EditProfileDelegate?) -> UIViewController {
        let view = EditProfileViewController()
        // MOCK: пока просто передаю напрямую UserService.shared
        let presenter = EditProfilePresenter(view: view, userService: UserService.shared, delegate: editProfileDelegate)
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
