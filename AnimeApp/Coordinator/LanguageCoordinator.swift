//
//  LanguageCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 12.06.2023.
//

import UIKit

class LanguageCoordinator: CoordinatorProtocol {
    private let moduleFactory: ModuleFactoryProtocol
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        
    }
}
