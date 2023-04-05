//
//  FirebaseAuthenticationService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 28.03.2023.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationService: AuthenticationService {
    
    public static var user: User? {
        return FirebaseAuth.Auth.auth().currentUser
    }
    
    func register(name: String, email: String, password: String, completion:  @escaping ((Error?) -> Void)) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(error)
                return
            }
            completion(nil)
            FirestoreManager.shared.insertUser(with: IlymaxUser(name: name, emailAddress: email, profilePictureUrl: nil))
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
            completion(nil)
        }
    }
    
}

