//
//  CoordinatorFactory.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController) -> PersonalMenuCoordinator
    static func createLanguageCoordinator(with navigationController: UINavigationController) -> LanguageCoordinator
}

struct CoordinatorFactory: CoordinatorFactoryProtocol {
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController) -> PersonalMenuCoordinator {
        return PersonalMenuCoordinator(navigationController: navigationController)
    }
    
    static func createLanguageCoordinator(with navigationController: UINavigationController) -> LanguageCoordinator {
        return LanguageCoordinator(navigationController: navigationController)
    }
}
