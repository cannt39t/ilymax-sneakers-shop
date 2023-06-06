//
//  LoginPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation
import FirebaseAuth

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
                notValid(error, text: nil)
            }
        }
    }
    
    func valid(_ email: String, _ password: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout(text: nil)
            self?.view?.showLoader()
            self?.login(email: email, password: password)
        }
    }
    
    func notValid(_ error: Error, text: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupLayout(validationError: error as? ValidationError, text: text)
        }
    }
    
    func switchToSignUpPage() {
        coordinator.changeToSignup()
    }
    
    func login(email: String, password: String) {
        authenticationService.login(email: email, password: password) { [weak self] error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    self?.view?.hideLoader()
                }
                if let authError = AuthErrorCode.Code(rawValue: error.code) {
                    switch authError {
                        case .invalidEmail:
                            let error = ValidationError(atIndex: 0, type: .invalidEmail)
                            self?.notValid(error, text: "Enter valid email address")
                        case .userNotFound:
                            let error = ValidationError(atIndex: 0, type: .invalidEmail)
                            self?.notValid(error, text: "User not found")
                        case .wrongPassword:
                            let error = ValidationError(atIndex: 1, type: .invalidPassword)
                            self?.notValid(error, text: "Wrong password")
                        case .networkError:
                            self?.view?.showAlert(error, text: "Couldn't connect to the database. Network Error occured.")
                        case .tooManyRequests:
                            self?.view?.showAlert(error, text: "Too many requests")
                        default:
                            self?.view?.showAlert(error, text: "Unknown error")
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self?.view?.hideLoader()
            }
        }
    }
}
