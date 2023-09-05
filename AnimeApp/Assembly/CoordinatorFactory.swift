//
//  CoordinatorFactory.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    static func createHomeCoordinator(with navigationController: UINavigationController) -> HomeCoordinator
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController) -> PersonalMenuCoordinator
    static func createLanguageCoordinator(with navigationController: UINavigationController) -> LanguageCoordinator
    static func createEditProfileCoordinator(with navigationController: UINavigationController) -> EditProfileCoordinator
}

struct CoordinatorFactory: CoordinatorFactoryProtocol {
    static func createHomeCoordinator(with navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController)
    }
    
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController) -> PersonalMenuCoordinator {
        return PersonalMenuCoordinator(navigationController: navigationController)
    }
    
    static func createLanguageCoordinator(with navigationController: UINavigationController) -> LanguageCoordinator {
        return LanguageCoordinator(navigationController: navigationController)
    }
    
    static func createEditProfileCoordinator(with navigationController: UINavigationController) -> EditProfileCoordinator {
        return EditProfileCoordinator(navigationController: navigationController)
    }
}
