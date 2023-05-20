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
protocol PersonalMenuPresenterProtocol: AnyObject{
    init(view: PersonalMenuViewProtocol)
}

// MARK: - PersonalMenuPresenter
final class PersonalMenuPresenter: PersonalMenuPresenterProtocol {
    
    weak var view: PersonalMenuViewProtocol?
    
    init(view: PersonalMenuViewProtocol) {
        self.view = view
        buildMenu()
    }
    
    private func buildMenu() {
//        let member = PersonalMenuModel(sectionType: .account(type: ber),
//                                       isSelectable: true,
//                                       hasSeparator: true)
//        
//        let changePassword = PersonalMenuModel(sectionType: .account(type: .changePassword),
//                                               isSelectable: true,
//                                               hasSeparator: true)
//        
//        let notification = PersonalMenuModel(sectionType: .general(type: .notification),
//                                             isSelectable: true,
//                                             hasSeparator: true)
//        
//        let language = PersonalMenuModel(sectionType: .general(type: .language),
//                                         isSelectable: true,
//                                         hasSeparator: true)
//        
//        let country = PersonalMenuModel(sectionType: .general(type: .country),
//                                        isSelectable: true,
//                                        hasSeparator: true)
//        
//        let clearCache = PersonalMenuModel(sectionType: .general(type: .clearCache),
//                                         isSelectable: true,
//                                         hasSeparator: true)
//
//        menuData = [member, changePassword, notification, language, country, clearCache]
    }
    
}
