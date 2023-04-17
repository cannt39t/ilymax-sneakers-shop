//
//  StorageManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetURL
        case failedToUpdateProfileImage
    }
    
    /// Get image url from localStorage
    public func getImageUrlFromStorageUrl(_ imageUrl: String, completion: @escaping (Error?, URL?) -> Void) {
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child(imageUrl)
        
        // Fetch the download URL
        imageRef.downloadURL { url, error in
            if let error = error {
                completion(error, nil)
            } else {
                completion(nil, url)
            }
        }
    }
    
    /// Add image of user profile to database
    public func insertImageUser(_ userId: String, _ image: Data, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference()
        let imageRef = "users/images/\(userId).jpg"
        
        
        let userRef = storageRef.child(imageRef)

        // Upload the file to the path "users/images/custom_id.jpg"
        userRef.putData(image, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                completion(nil)
                return
            }
            userRef.downloadURL { (url, error) in
                guard url != nil else {
                    completion(nil)
                    return
                }
                FirestoreManager.shared.updateImageProfileUrl(for: userId, imageUrl: imageRef) { error in
                    guard error != nil else {
                        completion(nil)
                        return
                    }
                    completion(imageRef)
                }
            }
        }
    }
    
    /// Add image of user profile to database
    public func insertImageUser2(_ userId: String, _ image: Data, completion: @escaping UploadPictureCompletion) {
        let storageRef = storage.reference()
        let imageRef = "users/images/\(userId).jpg"
        let userRef = storageRef.child(imageRef)
        userRef.putData(image, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("failed to upload")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            userRef.downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get URL")
                    completion(.failure(StorageErrors.failedToGetURL))
                    return
                }
                let urlString = url.absoluteString
                print("Download url \(urlString)")
                
                FirestoreManager.shared.updateImageProfileUrl(for: userId, imageUrl: imageRef) { error in
                    if error != nil {
                        completion(.failure(StorageErrors.failedToUpdateProfileImage))
                        return
                    }
                    completion(.success(urlString))
                }
            }
        }
    }
    
    /// Add image of shoes to database
    public func insertImageShoes(_ shoesId: String, _ image: Data, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference()
        
        let imageRef = "shoes/images/\(shoesId).jpg"
        let shoesRef = storageRef.child(imageRef)

        // Upload the file to the path "shoes/images/custom_id.jpg"
        shoesRef.putData(image, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                completion(nil)
                return
            }
            shoesRef.downloadURL { (url, error) in
                guard url != nil else {
                    completion(nil)
                    return
                }
                completion(imageRef)
            }
        }
    }
    
}
