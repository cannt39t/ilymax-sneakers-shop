//
//  ProfileService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation
import FirebaseAuth
import UIKit
import Combine


class ProfileService {
    
    func getCurrentUser(completion: @escaping (IlymaxUser?) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getUser(with: currentUserId) { user in
            if let user {
                UserDefaults.standard.set(user.name, forKey: "currentUserName")
                UserDefaults.standard.set(user.emailAddress, forKey: "currentUserEmail")
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func uploadProfileImage(with image: UIImage, competion: @escaping StorageManager.UploadContentResult) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        StorageManager.shared.insertImageUser2(currentUserId, image.pngData()!) { result in
            competion(result)
        }
    }
    
    func getAdressCount(completion: @escaping (Result<Int, Error>) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getAddressCount(for: currentUserId) { result in
            completion(result)
        }
    }
    
    func getSaleListCount(completion: @escaping (Result<Int, Error>) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getShoeCountForCurrentUser(ownerId: currentUserId) { result in
            completion(result)
        }
    }
}
