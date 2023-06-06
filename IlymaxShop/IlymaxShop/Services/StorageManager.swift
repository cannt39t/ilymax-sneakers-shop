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
    
    public typealias UploadContentResult = (Result<String, Error>) -> Void
    
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
    public func insertImageUser2(_ userId: String, _ image: Data, completion: @escaping UploadContentResult) {
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
                
                FirestoreManager.shared.updateImageProfileUrl(for: userId, imageUrl: urlString) { error in
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
                completion(url!.absoluteString)
            }
        }
    }
    
    public func getImageUrlFromStorageUrlProfileByEmail(email: String, completion: @escaping (URL?) -> Void) {
        FirestoreManager.shared.getUserByEmail(with: email) { [weak self] user in
            guard let user = user else {
                completion(nil)
                return
            }
            
            guard let profilePictureUrl = user.profilePictureUrl else {
                completion(nil)
                return
            }
            
            self?.getImageUrlFromStorageUrl(profilePictureUrl) { error, urlString in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                guard let profilePictureUrl = urlString else {
                    completion(nil)
                    return
                }
                
                completion(profilePictureUrl)
            }
        }
    }
    
    
    /// Upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, filename: String, completion: @escaping UploadContentResult) {
        let storageRef = storage.reference()
        let imageRef = "message_images/\(filename)"
        let userRef = storageRef.child(imageRef)
        userRef.putData(data, metadata: nil) { (metadata, error) in
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
                completion(.success(urlString))
            }
        }
    }
    
    /// Upload video that will be sent in a conversation message
    public func uploadMessageVideo(file: URL, filename: String, completion: @escaping UploadContentResult) {
        let name = filename
        do {
            let data = try Data(contentsOf: file)
            
            let storageRef = storage.reference().child("message_videos").child(name)
            if let uploadData = data as Data? {
                let metaData = StorageMetadata()
                metaData.contentType = "video/mp4"
                storageRef.putData(uploadData, metadata: metaData, completion: { (metadata, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else{
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                completion(.failure(StorageErrors.failedToGetURL))
                                return
                            }
                            completion(.success(downloadURL.absoluteString))
                        }
                    }
                })
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
