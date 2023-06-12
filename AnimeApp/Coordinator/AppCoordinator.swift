//
//  AppCoordinator.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    let navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    
    private var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
