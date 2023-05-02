//
//  RegistrationValidators.swift
//  AnimeApp
//
//  Created by Marat on 02.05.2023.
//

import Foundation

// MARK: - RegistrationError
enum RegistrationError: Error {
    case incorrectEmail
    case incorrectUsername
    case incorrectPassword
    case incorrectRepeatPassword
    case differentPasswords
}

extension RegistrationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectEmail:
            return "Wrong email"
        case .incorrectUsername:
            return "Wrong username"
        case .incorrectPassword:
            return "Wrong password"
        case .incorrectRepeatPassword:
            return "Wrong repeted password"
        case .differentPasswords:
            return "Different passwords"
        }
    }
}

// MARK: - RegistrationValidatorProtocol
protocol RegistrationValidatorProtocol: AnyObject {
    var nextValidator: RegistrationValidatorProtocol? { get set }
    
    func validate(model: Registration) -> Error?
    func setNext(validator: RegistrationValidatorProtocol)
}

extension RegistrationValidatorProtocol {
    func setNext(validator: RegistrationValidatorProtocol) {
        nextValidator = validator
    }
}

class RegistrationValidation {
    private var validators: [RegistrationValidatorProtocol] = []
    
    init() {
        validators = [
            RegistrationEmailValidator(),
            RegistrationUsernameValidator(),
            RegistrationPasswordValidator()
        ]
        
        validators.dropLast().enumerated().forEach {
            $0.element.setNext(validator: validators[$0.offset + 1])
        }
    }
    
    func validate(model: Registration) -> Error? {
        return validators.first?.validate(model: model)
    }
}

// MARK: - RegistrationEmailValidator
class RegistrationEmailValidator: RegistrationValidatorProtocol {
    var nextValidator: RegistrationValidatorProtocol?
    
    func validate(model: Registration) -> Error? {
        guard let email = model.email else { return RegistrationError.incorrectEmail }
        
        if !email.isEmail {
            return RegistrationError.incorrectEmail
        }
        
        return nextValidator?.validate(model: model)
    }
}

// MARK: - RegistrationUsernameValidator
class RegistrationUsernameValidator: RegistrationValidatorProtocol {
    private let usernameMinLength = 3
    
    var nextValidator: RegistrationValidatorProtocol?
    
    func validate(model: Registration) -> Error? {
        guard let username = model.username else { return RegistrationError.incorrectUsername }
        
        if username.count < usernameMinLength {
            return RegistrationError.incorrectUsername
        }
        
        return nextValidator?.validate(model: model)
    }
}

// MARK: - RegistrationPasswordValidator
class RegistrationPasswordValidator: RegistrationValidatorProtocol {
    var nextValidator: RegistrationValidatorProtocol?
    
    func validate(model: Registration) -> Error? {
        return nextValidator?.validate(model: model)
    }
}
