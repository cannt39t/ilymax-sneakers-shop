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
        print("найти \(email)")
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value is String else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: User) {
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "email": user.emailAddress
        ])
    }
    
}
