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
                    let imageUrl = doc.data()["image_url"] as? String,
                    let shoesIds = doc.data()["shoes_ids"] as? [String] {
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
                // Data for "images/promotionId.jpg" is returned
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
            "condition": shoes.condition,
            "image_url": shoes.imageUrl ?? "",
            "data": shoes.data.map { ["size": $0.size, "price": $0.price, "quantity": $0.quantity] },
            "owner_id": shoes.ownerId,
            "company": shoes.company,
            "category": shoes.category,
            "lowest_price": shoes.lowestPrice
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
    
    
    /// Update "imageUrl" of entity Shoes
    private func updateImageUrl(for documentID: String, imageUrl: String) {
        let shoesRef = db.collection("shoes").document(documentID)
        shoesRef.updateData([
            "image_url": imageUrl,
            "id": documentID
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
    
    /// Get all shoes from Database
    public func getAllShoes(completion: @escaping ([Shoes]?, Error?) -> Void) {
        db.collection("shoes").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil, nil)
                return
            }
            
            var shoes: [Shoes] = []
            
            for document in snapshot.documents {
                let data = document.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let color = data["color"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let imageUrl = data["image_url"] as? String ?? ""
                let ownerId = data["owner_id"] as? String ?? ""
                let company = data["company"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let condition = data["condition"] as? String ?? ""
                
                guard let dataArr = data["data"] as? [[String: Any]] else {
                    completion(nil, nil)
                    return
                }
                
                var shoeData: [ShoesDetail] = []
                
                for dict in dataArr {
                    let size = dict["size"] as? String ?? ""
                    let price = dict["price"] as? Double ?? 0
                    let quantity = dict["quantity"] as? Int ?? 0
                    
                    let shoe = ShoesDetail(size: size, price: Float(price), quantity: quantity)
                    shoeData.append(shoe)
                }
                
                let shoe = Shoes(id: id, name: name, description: description, color: color, gender: gender, condition: condition, imageUrl: imageUrl, data: shoeData, ownerId: ownerId, company: company, category: category)
                shoes.append(shoe)
            }
            
            completion(shoes, nil)
        }
    }
}

// MARK: - Category managment

extension FirestoreManager {
    
    /// Get all categories
    public func getAllCategories(completion: @escaping ([IlymaxCategory]) -> Void) {
        db.collection("categories").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
                return
            }
            var categories: [IlymaxCategory] = []
            for doc in querySnapshot!.documents {
                if let name = doc.data()["name"] as? String,
                    let imageUrl = doc.data()["image_url"] as? String {
                    let category = IlymaxCategory(name: name, imageUrl: imageUrl)
                    categories.append(category)
                }
            }
            completion(categories)
        }
    }
    
    /// Get all categories like array of names
    public func getAllCategoriesStrings(completion: @escaping ([String]) -> Void) {
        db.collection("categories").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
                return
            }
            var categories: [String] = []
            for doc in querySnapshot!.documents {
                if let name = doc.data()["name"] as? String {
                    categories.append(name)
                }
            }
            completion(categories)
        }
    }
    
    
    /// Get image from url shoes
    public func getImageCategory(_ imageUrl: String, completion: @escaping (Error?, UIImage?) -> Void) {
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

// MARK: - Storage managment

extension FirestoreManager {
    
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
    
}


