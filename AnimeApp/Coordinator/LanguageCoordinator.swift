//
//  LanguageCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 12.06.2023.
//

import UIKit

// MARK: - UpdatableWithLanguage
protocol UpdatableWithLanguage: AnyObject {
    var language: String { get set }
}

// MARK: - LanguageCoordinator
class LanguageCoordinator: CoordinatorProtocol {
    // MARK: - private properties
    private let moduleFactory: ModuleFactoryProtocol
    // TODO: it just mock
    private var language: String = "English" { didSet { updateLanguage() } }
    // MARK: - public properties
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    weak var delegate: LanguageUpdatingDelegate?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    // MARK: - public methods
    func start() {
        showLanguage()
    }
    
    // MARK: - private methods
    private func showLanguage() {
        let view = moduleFactory.createLanguageModule(languageDelegate: self)
        
        if var view = view as? FlowCoordinator {
            view.completionHandler = { [weak self] flag in
                print("pop showLanguage")
                self?.navigationController.popViewController(animated: flag)
                self?.finish()
            }
        }
        navigationController.pushViewController(view, animated: true)
    }
    
    private func updateLanguage() {
        
        // updating for all view
        navigationController.viewControllers.forEach {
            ($0 as? UpdatableWithLanguage)?.language = language
        }
        
        // updating for all child coordinators
        childCoordinators.forEach {
            ($0 as? LanguageUpdatingDelegate)?.update(with: language)
        }
        
        delegate?.update(with: language)
        
        print(language)
    }
}

// MARK: - LanguageUpdatingDelegate
extension LanguageCoordinator: LanguageUpdatingDelegate {
    func update(with language: String) {
        self.language = language
    }
}
