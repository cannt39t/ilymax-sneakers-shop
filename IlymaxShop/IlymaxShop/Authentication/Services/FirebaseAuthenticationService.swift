//
//  FirebaseAuthenticationService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 28.03.2023.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationService: AuthenticationService {
    
    
    func register(name: String, email: String, password: String, completion:  @escaping ((Error?) -> Void)) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(error)
                return
            }
            DatabaseManager.shared.insertUser(with: User(name: name, emailAddress: email))
        }
    }

    
    func login(email: String, password: String, completion:  @escaping ((Error?) -> Void)) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                completion(error)
                return
            }
            let user = result.user
            print("Login with: \(user)")

        }
    }
    
}

