//
//  ModuleBuilder.swift
//  AnimeApp
//
//  Created by Marat on 21.05.2023.
//

import UIKit

// MARK: - ModuleBuilderProtocol
protocol ModuleBuilderProtocol {
    static func createMainTabBarModule() -> UIViewController
    static func createAuthorizationModule() -> UIViewController
    static func createPesonalMenuModule() -> UIViewController
}

// MARK: - ModuleBuilder
struct ModuleBuilder: ModuleBuilderProtocol {
    
    static func createMainTabBarModule() -> UIViewController {
        return MainTabBarController()
    }
    
    static func createAuthorizationModule() -> UIViewController {
        let view = AuthorizationViewController()
        let presenter = AuthorizationPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func createPesonalMenuModule() -> UIViewController {
        let view = PersonalMenuViewController()
        let presenter = PersonalMenuPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
