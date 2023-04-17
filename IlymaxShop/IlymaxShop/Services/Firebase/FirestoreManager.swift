//
//  FirestoreManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


final class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
}


// MARK: - Users managment

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
        let usersRef = db.collection("users")
        
        usersRef.document(FirebaseAuth.Auth.auth().currentUser!.uid).setData([
            "name": user.name,
            "email": user.emailAddress,
        ])
    }
    
    public func getUser(with id: String, completion: @escaping (IlymaxUser?) -> Void) {
        let docRef = db.collection("users").document(id)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let user = IlymaxUser(name: data["name"] as! String, emailAddress: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String)
                completion(user)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    /// Update "imageUrl" of entity User
    public func updateImageProfileUrl(for documentID: String, imageUrl: String, completion: @escaping ((Error?) -> Void)) {
        let shoesRef = db.collection("users").document(documentID)
        shoesRef.updateData([
            "profilePictureUrl": imageUrl,
        ]) { err in
            if let err = err {
                print(err)
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    /// Search users with search query
    public func getUsersExceptCurrent(completion: @escaping ([IlymaxUser]) -> Void) {
        guard let currentUserID = FirebaseAuth.Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let usersRef = db.collection("users")
        
        usersRef
            .whereField(FieldPath.documentID(), isNotEqualTo: currentUserID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([])
                } else {
                    var users: [IlymaxUser] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let user = IlymaxUser(name: data["name"] as! String, emailAddress: data["email"] as! String, profilePictureUrl: data["profilePictureUrl"] as? String)
                        users.append(user)
                    }
                    completion(users)
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
                StorageManager.shared.insertImageShoes(ref!.documentID, image.pngData()!) { url in
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
    
    
    /// Update "imageUrl" of entity Shoes
    public func updateImageUrl(for documentID: String, imageUrl: String) {
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
    
}


