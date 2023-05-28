//
//  CoordinatorFactory.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController) -> PersonalMenuCoordinator
}

struct CoordinatorFactory: CoordinatorFactoryProtocol {
    static func createPersonalMenuCoordinator(with navigationController: UINavigationController) -> PersonalMenuCoordinator {
        return PersonalMenuCoordinator(navigationController: navigationController)
    }
}
