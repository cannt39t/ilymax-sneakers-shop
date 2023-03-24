//
//  SignUpPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation


class SignUpPresenter {
    
    var view: SignUpViewController?
    private var authenticationService: AuthenticationService = MockAuthenticationService.shared
    private var userService: UserService = MockUserService.shared
    var coordinator: AuthenticationCoordinator!
    
    func checkAvailableEmail(email: String) throws {
        if (userService.getUserByEmail(email: email)) != nil {
            throw ValidationError.init(atIndex: 1, type: .emailAlreadyInUse)
        }
    }
    
    func register(name: String, email: String, password: String) {
        authenticationService.register(name: name, email: email, password: password)
        coordinator.startProfile()
    }
    
    func switchToLoginPage() {
        coordinator.changeToLogin()
    }
    
}
