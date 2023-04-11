//
//  ProfileService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation
import FirebaseAuth


class ProfileService {
    
    func getCurrentUser() -> IlymaxUser {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        return FirestoreManager.shared.getUserByID(with: currentUserId)
    }
    
}
