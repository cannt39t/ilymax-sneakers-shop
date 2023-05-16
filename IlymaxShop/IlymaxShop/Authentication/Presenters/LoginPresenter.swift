//
//  LoginPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

class LoginPresenter {
    
    weak var view: LoginViewController?
    private var authenticationService: AuthenticationService = FirebaseAuthenticationService()
    weak var coordinator: AuthenticationCoordinator!
    
    public func validation(_ email: String?, _ password: String?) {
        DispatchQueue.global().sync {
            do {
                
                // Empty
                
                guard let textEmail = email, !textEmail.isEmpty else {
                    throw ValidationError(atIndex: 0, type: .emptyField)
                }
                guard let textPassword = password, !textPassword.isEmpty else {
                    throw ValidationError(atIndex: 1, type: .emptyField)
                }
                
                // Email
                
                if !ValidationError.validateEmail(email: textEmail) {
                    throw ValidationError(atIndex: 0, type: .invalidEmail)
                }
                
                // Number of chars
                
                if textPassword.count < 8 {
                    throw ValidationError(atIndex: 1, type: .shortPassword)
                }
                
                valid(textEmail, textPassword)
                
            } catch {
                notValid(error)
            }
        }
    }
    
    func valid(_ email: String, _ password: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout()
            self?.view?.showLoader()
            self?.login(email: email, password: password)
        }
    }
    
    func notValid(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout(validationError: error as? ValidationError)
        }
    }
    
    func switchToSignUpPage() {
        coordinator.changeToSignup()
    }
    
    func login(email: String, password: String) {
        authenticationService.login(email: email, password: password) { [weak self] error in
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
    
}
