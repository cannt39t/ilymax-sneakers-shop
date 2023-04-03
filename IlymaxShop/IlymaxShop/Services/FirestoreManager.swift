//
//  FirestoreManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
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


// MARK: - Promotion managment


extension FirestoreManager {
    
    /// Get all promotions
    public func getAllPromotions(completion: @escaping ([Promotion]) -> Void) {
        db.collection("promotions").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
                return
            }
            var promotions: [Promotion] = []
            for doc in querySnapshot!.documents {
                if let name = doc.data()["name"] as? String,
                    let imageUrl = doc.data()["imageUrl"] as? String,
                    let shoesIds = doc.data()["shoesIds"] as? [String] {
                    let promotion = Promotion(name: name, imageUrl: imageUrl, shoesIds: shoesIds)
                    promotions.append(promotion)
                }
            }
            completion(promotions)
        }
    }

    
    public func getImagePromotion(_ imageUrl: String, completion: @escaping (Error?, UIImage?) -> Void) {
        let storageRef = storage.reference()

        let islandRef = storageRef.child(imageUrl)

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 700) { data, error in
            if let error = error {
                completion(error, nil)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                completion(nil, image)
            }
        }
    }
    
}
    
    
// MARK: - Shoes managment

extension FirestoreManager {
    
    /// Insert shoes to database
    public func insertShoes(with shoes: Shoes, image: UIImage) {
        var ref: DocumentReference? = nil
        ref = db.collection("shoes").addDocument(data: [
            "name": shoes.name,
            "description": shoes.description,
            "color": shoes.color,
            "gender": shoes.gender,
            "imageUrl": shoes.imageUrl ?? "",
            "data": shoes.data.map { ["size": $0.size, "price": $0.price, "quantity": $0.quantity] },
            "ownerId": shoes.ownerId,
            "company": shoes.company,
            "category": shoes.category
        ]) { [weak self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self?.insertImageShoes(ref!.documentID, image.pngData()!) { url in
                    if let url {
                        print("Added image of shoes with URL: \(url)")
                        self?.updateImageUrl(for: ref!.documentID, imageUrl: url)
                    } else {
                        print("Could not upload image of shoes with ID: \(ref!.documentID)")
                    }
                }
            }
        }
    }
    
    /// Add image of shoes to database
    private func insertImageShoes(_ shoesId: String, _ image: Data, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference()
        
        let imageRef = "shoes/images/\(shoesId).jpg"
        let shoesRef = storageRef.child(imageRef)

        // Upload the file to the path "shoes/images/custom_id.jpg"
        let uploadTask = shoesRef.putData(image, metadata: nil) { (metadata, error) in
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
    
    
    /// Update "imageUrl" of entity Shoes
    private func updateImageUrl(for documentID: String, imageUrl: String) {
        let shoesRef = db.collection("shoes").document(documentID)
        shoesRef.updateData([
            "imageUrl": imageUrl
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document updated with new image URL")
            }
        }
    }
    

    
    /// Get image from url shoes
    public func getImageShoes(_ imageUrl: String, completion: @escaping (Error?, UIImage?) -> Void) {
        let storageRef = storage.reference()
        
        let islandRef = storageRef.child(imageUrl)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(error, nil)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                completion(nil, image)
            }
        }
    }
    
}
