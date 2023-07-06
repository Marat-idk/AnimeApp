//
//  EditProfilePresenter.swift
//  AnimeApp
//
//  Created by Марат on 02.07.2023.
//

import Foundation

// MARK: - EditProfileDelegate
protocol EditProfileDelegate: AnyObject {
    func update(with userPersonal: UserPersonal)
}

// MARK: - EditProfileViewProtocol
protocol EditProfileViewProtocol: AnyObject {
    func updateUserPersonal(with personal: UserPersonal)
    func showEditFail(of type: PersonalInfoType)
    func enableSaveButton()
    func update(with userPersonal: UserPersonal)
}

// MARK: - EditProfilePresenterProtocol
protocol EditProfilePresenterProtocol: AnyObject {
    init(view: EditProfileViewProtocol, userService: UserServiceProtocol, delegate: EditProfileDelegate?)
    func getUserPersonal()
    func checkInput(text: String, _ type: PersonalInfoType)
    func save(name: String, email: String, password: String, phone: String)
}

// MARK: - EditProfilePresenter
final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    weak var view: EditProfileViewProtocol?
    private var userService: UserServiceProtocol
    weak var delegate: EditProfileDelegate?
    
    // MARK: - init
    init(view: EditProfileViewProtocol, userService: UserServiceProtocol, delegate: EditProfileDelegate?) {
        self.view = view
        self.userService = userService
        self.delegate = delegate
    }
    
    // MARK: - view to presenter
    func getUserPersonal() {
        // doing some shit
        view?.updateUserPersonal(with: userService.userPersonal)
    }
    
    // возможно стоит валидатор добавить
    func checkInput(text: String, _ type: PersonalInfoType) {
        switch type {
        case .name:
            if text == userService.userPersonal.firstName {
                view?.showEditFail(of: type)
                return
            }
        default:
            break
        }
        view?.enableSaveButton()
    }
    
    // FIXME: - password don't saves
    func save(name: String, email: String, password: String, phone: String) {
        var userPersonal = userService.userPersonal
        userPersonal.firstName = name
        userPersonal.email = email
        userPersonal.phone = phone
        userService.save(new: userPersonal)
        delegate?.update(with: userPersonal)
        view?.update(with: userPersonal)
    }
}
