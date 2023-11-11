//
//  PersonalMenuCoordinator.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit
// FIXME: - DELETE
import SnapKit

// MARK: - PersonalMenuCoordinator
class PersonalMenuCoordinator: CoordinatorProtocol {
    // MARK: - public properties
    private let moduleFactory: ModuleFactoryProtocol
    private var userPersonal: UserPersonal { didSet { updateUserPersonal() } }
    private var language: String = "English"
    
    // MARK: - public properties
    var childCoordinators: [CoordinatorProtocol] = []
    let navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    
    // MARK: - init
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        // TODO: - inject it from outside
        self.userPersonal = UserService.shared.userPersonal
    }
    
    // MARK: - public methods
    func start() {
        showPersonalMenu()
    }
    
    // MARK: - private methods
    private func showPersonalMenu() {
        let personalMenu = moduleFactory.createPesonalMenuModule(navigationDelegate: self)
        navigationController.pushViewController(personalMenu, animated: true)
    }
    
    private func showProfileEditFlow() {
        let editProfileFlow = CoordinatorFactory.createEditProfileCoordinator(with: navigationController)
        editProfileFlow.flowCompletionHandler = {
            print("editProfileFlow finished")
            self.childCoordinators.removeLast()
        }
        editProfileFlow.delegate = self
        editProfileFlow.start()
        childCoordinators.append(editProfileFlow)
        print(childCoordinators)
    }
    
    private func showProfileFlow() {
        
    }
    
    private func showChangePasswordFlow() {
        
    }
    
    // ...
    // ...
    // ...
    
    private func showNotification() {
        let view = moduleFactory.createNotificationModule()
        navigationController.pushViewController(view, animated: true)
    }
    
    private func showLanguage() {
        let languageCoordinator = CoordinatorFactory.createLanguageCoordinator(with: navigationController)
        languageCoordinator.delegate = self
        languageCoordinator.flowCompletionHandler = { [weak self] in
            self?.childCoordinators.removeLast()
            print(self?.navigationController.viewControllers.count)
        }
        languageCoordinator.start()
        childCoordinators.append(languageCoordinator)
        print(childCoordinators)
    }
    
    private func showPrivacyPolicy() {
        let view = moduleFactory.createPrivacyPolicyModule()
        
        if var view = view as? FlowCoordinator {
            view.completionHandler = { [weak self] flag in
                print("poping showPrivacyPolicy")
                self?.navigationController.popViewController(animated: flag)
            }
        }
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func showLogoutPopup() {
        let popupView = PopupView()
        popupView.type = .logout
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func onProfileEditOptionsSelected(_ item: ProfileEditOptions) {
        switch item {
        case .profileEdit:
            showProfileEditFlow()
            print(ProfileEditOptions.profileEdit)
        }
    }
    
    private func onAccountOptionsSelected(_ item: AccountOptions) {
        switch item {
        case .member:
            print(AccountOptions.member.description)
        case .changePassword:
            print(AccountOptions.changePassword.description)
        }
    }
    
    private func onGeneralOptionsSelected(_ item: GeneralOptions) {
        switch item {
        case .notification:
            showNotification()
        case .language:
            showLanguage()
        case .country:
            print(GeneralOptions.country.description)
        case .clearCache:
            print(GeneralOptions.clearCache.description)
        }
    }
    
    private func onMoreOptionsSelected(_ item: MoreOptions) {
        switch item {
        case .legalAndPolicies:
            showPrivacyPolicy()
        case .helpFeedback:
            print(MoreOptions.helpFeedback.description)
        case .aboutUs:
            print(MoreOptions.aboutUs.description)
        }
    }
    
    private func onLogoutOptionsSelected(_ item: LogoutOptions) {
        switch item {
        case .logout:
            showLogoutPopup()
        }
    }
    
    private func updateUserPersonal() {
        // updating for all view
        navigationController.viewControllers.forEach {
            // пропускаю EditProfileViewController, чтобы избежать зацикливания
            // shit solution, must be refactored
            print("~~~~ PersonalMenuCoordinator \($0)")
            if $0 is EditProfileViewController { return }
            ($0 as? UpdatableWithUserPersonal)?.update(userPersonal)
        }
        
        // updating for all child coordinators
        childCoordinators.forEach {
            // пропускаю EditProfileCoordinator, чтобы избежать зацикливания
            // shit solution, must be refactored
            if $0 is EditProfileCoordinator { return }
            ($0 as? EditProfileDelegate)?.update(with: userPersonal)
        }
    }
}

// MARK: - PersonalMenuNavigationDelegate
extension PersonalMenuCoordinator: PersonalMenuNavigationDelegate {
    func onSelectedItem<T: PersonalMenuCellType>(_ item: T) {
        
        switch item {
        case let option as ProfileEditOptions:
            onProfileEditOptionsSelected(option)
        case let option as AccountOptions:
            onAccountOptionsSelected(option)
        case let option as GeneralOptions:
            onGeneralOptionsSelected(option)
        case let option as MoreOptions:
            onMoreOptionsSelected(option)
        case let option as LogoutOptions:
            onLogoutOptionsSelected(option)
        default:
            print("unknown option")
        }
        
//        print(navigationController.viewControllers.count)
    }
}

// MARK: - EditProfileDelegate
extension PersonalMenuCoordinator: EditProfileDelegate {
    func update(with userPersonal: UserPersonal) {
        self.userPersonal = userPersonal
    }
}

// MARK: - LanguageUpdatingDelegate
extension PersonalMenuCoordinator: LanguageUpdatingDelegate {
    func update(with language: String) {
        self.language = language
        print(language)
    }
}
