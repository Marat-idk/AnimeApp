//
//  AuthorizationValidators.swift
//  AnimeApp
//
//  Created by Marat on 01.05.2023.
//

import Foundation

// MARK: - AuthorizationError
enum AuthorizationError: Error {
    case incorrectEmail
    case incorrectUsername
    case incorrectPassword
}

extension AuthorizationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectEmail:
            return "Wrong email"
        case .incorrectUsername:
            return "Wrong username"
        case .incorrectPassword:
            return "Wrong password"
        }
    }
}

// MARK: - AuthorizationValidatorProtocol
protocol AuthorizationValidatorProtocol: AnyObject {
    var nextValidator: AuthorizationValidatorProtocol? { get set }
    
    func validate(model: Authorization) -> Error?
    func setNext(validator: AuthorizationValidatorProtocol)
}

extension AuthorizationValidatorProtocol {
    func setNext(validator: AuthorizationValidatorProtocol) {
        nextValidator = validator
    }
}

// MARK: - AuthorizationValidation
class AuthorizationValidation {
    private var validators: [AuthorizationValidatorProtocol] = []
    
    init(type: AuthorizationLoginType) {
        switch type {
        case .email:
            validators = [
                AuthorizationEmailValidator(),
                AuthorizationPasswordValidator()
            ]
        case .username:
            validators = [
                AuthorizationUsernameValidator(),
                AuthorizationPasswordValidator()
            ]
        }
        
        validators.dropLast().enumerated().forEach({
            $0.element.setNext(validator: validators[$0.offset + 1])
        })
    }
    
    func validate(model: Authorization) -> Error? {
        return validators.first?.validate(model: model)
    }
}

// MARK: - AuthorizationEmailValidator
class AuthorizationEmailValidator: AuthorizationValidatorProtocol {
    var nextValidator: AuthorizationValidatorProtocol?
    
    func validate(model: Authorization) -> Error? {
        guard let email = model.email else { return AuthorizationError.incorrectEmail }
        
        if !email.isEmail {
            return AuthorizationError.incorrectEmail
        }
        
        return nextValidator?.validate(model: model)
    }
}

// MARK: - AuthorizationUsernameValidator
class AuthorizationUsernameValidator: AuthorizationValidatorProtocol {
    private let usernameMinLength = 3
    
    var nextValidator: AuthorizationValidatorProtocol?
    
    func validate(model: Authorization) -> Error? {
        guard let username = model.username else { return AuthorizationError.incorrectUsername }
        
        if username.count < usernameMinLength {
            return AuthorizationError.incorrectUsername
        }
        
        return nextValidator?.validate(model: model)
    }
}

// MARK: - AuthorizationPasswordValidator
// TODO: добавить проверку на то, что у пароля есть цифры, лат. буквы и символ
class AuthorizationPasswordValidator: AuthorizationValidatorProtocol {
    
    var nextValidator: AuthorizationValidatorProtocol?
    
    func validate(model: Authorization) -> Error? {
        guard let password = model.password else { return AuthorizationError.incorrectPassword }
        
        return nextValidator?.validate(model: model)
    }
}
