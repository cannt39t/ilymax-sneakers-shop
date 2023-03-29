//
//  SignUpPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

class SignUpPresenter {
    
    var view: SignUpViewController?
    private var authenticationService: AuthenticationService = FirebaseAuthenticationService()
    private var userService: UserService = MockUserService.shared
    var coordinator: AuthenticationCoordinator!

    func checkAvailableEmail(email: String, completion: @escaping (Bool) -> Void) {
        let safeEmail = Security.getSafeEmail(email: email)
        
        DatabaseManager.shared.userExists(with: safeEmail) { value in
            completion(value)
        }
    }
    
    func validation(_ name: String?, _ email: String?, _ password: String?, _ confirmPassword: String?) {
        DispatchQueue.global().sync {
            do {
                
                // Empty
                
                guard let textName = name, !textName.isEmpty else {
                    throw ValidationError(atIndex: 0, type: .emptyField)
                }
                guard let textEmail = email, !textEmail.isEmpty else {
                    throw ValidationError(atIndex: 1, type: .emptyField)
                }
                guard let textPassword = password, !textPassword.isEmpty else {
                    throw ValidationError(atIndex: 2, type: .emptyField)
                }
                guard let textPasswordConfirm = confirmPassword, !textPasswordConfirm.isEmpty else {
                    throw ValidationError(atIndex: 3, type: .emptyField)
                }
                
                // Email
                
                if !ValidationError.validateEmail(email: textEmail) {
                    throw ValidationError(atIndex: 1, type: .invalidEmail)
                }
                
                // Number of chars
                
                if textPassword.count < 8 {
                    throw ValidationError(atIndex: 2, type: .shortPassword)
                }
                
                // Mismatched Passwords
                
                if textPassword != textPasswordConfirm {
                    throw ValidationError(atIndex: 3, type: .mismatchedPasswords)
                }
                
                checkAvailableEmail(email: textEmail) { [weak self] exists in
                    print(exists)
                    if exists {
                        self?.didGetNotAvailableEmail(ValidationError(atIndex: 1, type: .emailAlreadyInUse))
                        return
                    } else {
                        self?.didGetAvailableEmail(name: textName, email: textEmail, password: textPassword)
                    }
                }
            } catch {
                didGetNotAvailableEmail(error)
            }
        }
    }
    
    func didGetAvailableEmail(name: String, email: String, password: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout()
            self?.register(name: name, email: email, password: password)
        }
    }
    
    func didGetNotAvailableEmail(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout(validationError: (error as? ValidationError))
        }
    }

    
    func register(name: String, email: String, password: String) {
        authenticationService.register(name: name, email: email, password: password) { error in
            if let e = error {
                fatalError()
            }
        }
        coordinator.startProfile()
    }
    
    func switchToLoginPage() {
        coordinator.changeToLogin()
    }
    
}
