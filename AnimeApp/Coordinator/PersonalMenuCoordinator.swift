//
//  PersonalMenuCoordinator.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

// MARK: - PersonalMenuCoordinator
class PersonalMenuCoordinator: CoordinatorProtocol {
    private let moduleFactory: ModuleFactoryProtocol
    private var language: String = "English"
    
    var childCoordinators: [CoordinatorProtocol] = []
    let navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        showPersonalMenu()
    }
    
    private func showPersonalMenu() {
        let personalMenu = moduleFactory.createPesonalMenuModule(navigationDelegate: self)
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
    
    private func onProfileEditOptionsSelected(_ item: ProfileEditOptions) {
        switch item {
        case .profileEdit:
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
            print(LogoutOptions.logout)
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

// MARK: - LanguageUpdatingDelegate
extension PersonalMenuCoordinator: LanguageUpdatingDelegate {
    func update(with language: String) {
        self.language = language
        print(language)
    }
}
