//
//  LoginPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

class LoginPresenter {
    
    private weak var view: LoginViewController?
    private var authenticationService: AuthenticationService = MockAuthenticationService.shared
    private var userService: UserService = MockUserService.shared
    weak var coordinator: AuthenticationCoordinator!
    
    public func emailExists(email: String) throws {
        if (userService.getUserByEmail(email: email)) == nil {
            throw ValidationError.init(atIndex: 0, type: .cannotFindEmail)
        }
    }
    
    public func validPassword(email: String, password: String) throws {
        if let user = userService.getUserByEmail(email: email) {
            if user.password != password {
                throw ValidationError.init(atIndex: 1, type: .invalidPassword)
            }
        }
    }
    
    func switchToSignUpPage() {
        coordinator.changeToSignup()
    }
    
    func login(email: String) {
        if let user = userService.getUserByEmail(email: email) {
            authenticationService.login(user: user)
        }
        coordinator.startProfile()
    }
    
}
