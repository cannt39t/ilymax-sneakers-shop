//
//  FirestoreManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import Foundation
import FirebaseFirestore


final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    
}


// MARK: - Account managment

extension FirestoreManager {
    
    /// Check if user exists with current email
    public func userExists(with email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("User with email \(email) does't exists")
                        completion(false)
                    } else {
                        print("User with email \(email) exists")
                        completion(true)
                    }
                }
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: IlymaxUser) {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "name": user.name,
            "email": user.emailAddress,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}

