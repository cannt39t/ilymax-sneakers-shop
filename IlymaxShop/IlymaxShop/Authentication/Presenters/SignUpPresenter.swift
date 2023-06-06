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
    var coordinator: AuthenticationCoordinator!

    func checkAvailableEmail(email: String, completion: @escaping (Bool) -> Void) {
        FirestoreManager.shared.userExists(with: email) { value in
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
                    if exists {
                        self?.notValid(ValidationError(atIndex: 1, type: .emailAlreadyInUse))
                        return
                    } else {
                        self?.valid(name: textName, email: textEmail, password: textPassword)
                    }
                }
            } catch {
                notValid(error)
            }
        }
    }
    
    func valid(name: String, email: String, password: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout()
            self?.view?.showLoader()
            self?.register(name: name, email: email, password: password)
        }
    }
    
    func notValid(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout(validationError: (error as? ValidationError))
        }
    }

    
    func register(name: String, email: String, password: String) {
        authenticationService.register(name: name, email: email, password: password) { [weak self] error in
            if let error {
                DispatchQueue.main.async {
                    self?.view?.hideLoader()
                    self?.view?.showAlert(error)
                }
                return
            }
            DispatchQueue.main.async {
                self?.view?.hideLoader()
            }
        }
    }
    
    func switchToLoginPage() {
        coordinator.changeToLogin()
    }
    
}
