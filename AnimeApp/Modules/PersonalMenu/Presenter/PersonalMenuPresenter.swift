//
//  PersonalMenuPresenter.swift
//  AnimeApp
//
//  Created by Marat on 14.05.2023.
//

import Foundation

// MARK: - PersonalMenuViewProtocol
protocol PersonalMenuViewProtocol: AnyObject {
    
}

// MARK: - PersonalMenuPresenterProtocol
protocol PersonalMenuPresenterProtocol: AnyObject {
    init(view: PersonalMenuViewProtocol, userService: UserServiceProtocol, navigationDelegate: PersonalMenuNavigationDelegate?)
    
    var userPersonal: UserPersonal { get }
    
    func menuItemDidSelect(at indexPath: IndexPath)
}

// MARK: - PersonalMenuNavigationDelegate
protocol PersonalMenuNavigationDelegate: AnyObject {
    func onSelectedItem<T: PersonalMenuCellType>(_ item: T)
}

// MARK: - PersonalMenuPresenter
final class PersonalMenuPresenter: PersonalMenuPresenterProtocol {
    
    weak var view: PersonalMenuViewProtocol?
    private var userService: UserServiceProtocol
    weak var navigationDelegate: PersonalMenuNavigationDelegate?
    
    var userPersonal: UserPersonal {
        userService.userPersonal
    }
    
    init(view: PersonalMenuViewProtocol, userService: UserServiceProtocol, navigationDelegate: PersonalMenuNavigationDelegate? = nil) {
        self.view = view
        self.userService = userService
        self.navigationDelegate = navigationDelegate
    }
    
    func menuItemDidSelect(at indexPath: IndexPath) {
        guard let section = PersonalMenuSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .profileEdit:
            navigationDelegate?.onSelectedItem(ProfileEditOptions.allCases[indexPath.item])
        case .account:
            navigationDelegate?.onSelectedItem(AccountOptions.allCases[indexPath.item])
        case .general:
            navigationDelegate?.onSelectedItem(GeneralOptions.allCases[indexPath.item])
        case .more:
            navigationDelegate?.onSelectedItem(MoreOptions.allCases[indexPath.item])
        case .logout:
            navigationDelegate?.onSelectedItem(LogoutOptions.allCases[indexPath.item])
        }
    }
}
