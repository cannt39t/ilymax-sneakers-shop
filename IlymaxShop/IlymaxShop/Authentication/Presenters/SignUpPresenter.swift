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

    func checkAvailableEmail(email: String) throws {
        
        let safeEmail = Security.getSafeEmail(email: email)
        
        DatabaseManager.shared.userExists(with: safeEmail) { exists in
            if exists {
                throw ValidationError.init(atIndex: 1, type: .emailAlreadyInUse)
            }
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
