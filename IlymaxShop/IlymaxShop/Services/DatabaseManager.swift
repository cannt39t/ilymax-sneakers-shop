//
//  DatabaseManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 28.03.2023.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

// MARK: - Account managment

extension DatabaseManager {
    
    /// Check if user exists with current email
    public func userExists(with email: String, completion: @escaping (Bool) -> Void) {
        print(email)
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            let exists = snapshot.exists()
            completion(exists)
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: IlymaxUser) {
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "email": user.emailAddress
        ])
    }
    
}
