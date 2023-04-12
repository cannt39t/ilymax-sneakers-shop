//
//  ProfileService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation
import FirebaseAuth
import UIKit


class ProfileService {
    
    func getCurrentUser(completion: @escaping (IlymaxUser?) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getUser(with: currentUserId) { user in
            if let user {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func uploadProfileImage(with image: UIImage) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.insertImageUser(currentUserId, image.pngData()!) { urlImage in
            print("here")
            if let urlImage {
                print(urlImage)
            } else {
                print("Could not upload image")
            }
        }
    }
    
}
