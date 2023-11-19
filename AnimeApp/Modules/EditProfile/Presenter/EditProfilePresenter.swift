//
//  EditProfilePresenter.swift
//  AnimeApp
//
//  Created by Марат on 02.07.2023.
//

//import Foundation
import UIKit

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
    func save(image: UIImage)
}

// MARK: - EditProfilePresenter
final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    weak var view: EditProfileViewProtocol?
    weak var delegate: EditProfileDelegate?
    private var userService: UserServiceProtocol
    private var userPersonal: UserPersonal? {
        didSet {
            guard let userPersonal = userPersonal else { return }
            userService.save(new: userPersonal)
            delegate?.update(with: userPersonal)
            view?.update(with: userPersonal)
        }
    }
    
    // MARK: - init
    init(view: EditProfileViewProtocol, userService: UserServiceProtocol, delegate: EditProfileDelegate?) {
        self.view = view
        self.userService = userService
        self.delegate = delegate
    }
    
    // MARK: - view to presenter
    func getUserPersonal() {
        // FIXME: doing some shit
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
    
    // FIXME: - password doesn't save
    func save(name: String, email: String, password: String, phone: String) {
        var userPersonal = userService.userPersonal
        userPersonal.firstName = name
        userPersonal.email = email
        userPersonal.phone = phone
        self.userPersonal = userPersonal
    }
    
    func save(image: UIImage) {
        var userPersonal = userService.userPersonal
        userPersonal.image = image
        self.userPersonal = userPersonal
    }
}
