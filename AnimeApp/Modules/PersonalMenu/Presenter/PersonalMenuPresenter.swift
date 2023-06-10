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
    init(view: PersonalMenuViewProtocol, navigationDelegate: PersonalMenuNavigationDelegate?)
    func menuItemDidSelect(at indexPath: IndexPath)
}

// MARK: - PersonalMenuNavigationDelegate
protocol PersonalMenuNavigationDelegate: AnyObject {
    func onSelectedItem<T: PersonalMenuCellType>(_ item: T)
}

// MARK: - PersonalMenuPresenter
final class PersonalMenuPresenter: PersonalMenuPresenterProtocol {
    
    weak var view: PersonalMenuViewProtocol?
    weak var navigationDelegate: PersonalMenuNavigationDelegate?
    
    init(view: PersonalMenuViewProtocol, navigationDelegate: PersonalMenuNavigationDelegate? = nil) {
        self.view = view
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
