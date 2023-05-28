//
//  PersonalMenuCoordinator.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

class PersonalMenuCoordinator: CoordinatorProtocol {
    let navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showPersonalMenu()
    }
    
    private func showPersonalMenu() {
        let personalMenu = ModuleFactory.createPesonalMenuModule(navigationDelegate: self)
        navigationController.pushViewController(personalMenu, animated: true)
    }
    
    private func showProfileEditFLow() {
        
    }
    
    private func showProfileFlow() {
        
    }
    
    private func showChangePasswordFlow() {
        
    }
    
    // ...
    // ...
    // ...
    
    private func showPrivacyPolicy() {
        
    }
}

extension PersonalMenuCoordinator: PersonalMenuNavigationDelegate {
    func onSelectedItem<T: PersonalMenuCellType>(_ item: T) {
        
        print(item)
    }
}
