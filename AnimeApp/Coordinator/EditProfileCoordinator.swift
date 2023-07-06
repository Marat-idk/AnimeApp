//
//  EditProfileCoordinator.swift
//  AnimeApp
//
//  Created by Марат on 06.07.2023.
//

import UIKit

// MARK: - UpdatableWithUserPersonal
protocol UpdatableWithUserPersonal: AnyObject {
    func update(_ userPersonal: UserPersonal)
}

// MARK: - EditProfileCoordinator
class EditProfileCoordinator: CoordinatorProtocol {
    private let moduleFactory: ModuleFactoryProtocol
    private var userPersonal: UserPersonal {
        didSet { updateUserPersonal() }
    }
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    var childCoordinators: [CoordinatorProtocol] = []
    weak var delegate: EditProfileDelegate?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        // TODO: - inject it from outside
        self.userPersonal = UserService.shared.userPersonal
    }

    func start() {
        showEditPrifile()
    }
    
    // MARK: - private methods
    private func showEditPrifile() {
        let view = moduleFactory.createEditProfileModule(editProfileDelegate: self)
        
        if var view = view as? FlowCoordinator {
            view.completionHandler = { [weak self] flag in
                print("poping showProfileEditFlow")
                self?.navigationController.popViewController(animated: true)
                self?.finish()
            }
        }
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func updateUserPersonal() {
        
        // updating for all view
        navigationController.viewControllers.forEach {
            ($0 as? UpdatableWithUserPersonal)?.update(userPersonal)
        }
        
        // updating for all child coordinators
        childCoordinators.forEach {
            ($0 as? EditProfileDelegate)?.update(with: userPersonal)
        }
        
        delegate?.update(with: userPersonal)
    }
}

// MARK: - EditProfileDelegate
extension EditProfileCoordinator: EditProfileDelegate {
    func update(with userPersonal: UserPersonal) {
        self.userPersonal = userPersonal
    }
}
