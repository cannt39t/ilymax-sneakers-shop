//
//  FirestoreManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MessageKit
import CoreLocation


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
    
    
    public func getUserByEmail(with email: String, completion: @escaping (IlymaxUser?) -> Void) {
        let usersRef = db.collection("users")
        
        usersRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents, error == nil else {
                completion(nil)
                return
            }
            
            guard let userDoc = documents.first else {
                completion(nil)
                return
            }
            
            let userData = userDoc.data()
            let name = userData["name"] as! String
            let emailAddress = userData["email"] as! String
            let profilePictureUrl = userData["profilePictureUrl"] as? String ?? ""
            let user = IlymaxUser(name: name, emailAddress: emailAddress, profilePictureUrl: profilePictureUrl)
            
            completion(user)
        }
    }

}


// MARK: - Promotion managment


extension FirestoreManager {
    
    /// Get all promotions
    public func getAllPromotions(completion: @escaping ([IlymaxPromotion]) -> Void) {
        db.collection("promotions").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
                return
            }
            var promotions: [IlymaxPromotion] = []
            for doc in querySnapshot!.documents {
                if let name = doc.data()["name"] as? String,
                    let imageUrl = doc.data()["image_url"] as? String,
                    let shoesIds = doc.data()["shoes_ids"] as? [String] {
                    let promotion = IlymaxPromotion(name: name, imageUrl: imageUrl, shoesIds: shoesIds)
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
            "data": shoes.data.map { ["size": $0.size, "price": $0.price, "quantity": $0.quantity] as [String : Any] },
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
    
    /// Get all shoes for a specific owner_id from Database
    public func getAllShoesForCurrentUser(ownerId: String, completion: @escaping (Result<[Shoes], Error>) -> Void) {
        let shoesRef = db.collection("shoes")
        let query = shoesRef.whereField("owner_id", isEqualTo: ownerId)
        
        query.getDocuments { (snapshot, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.success([]))
                return
            }
            
            var shoes: [Shoes] = []
            
            for document in snapshot.documents {
                let data = document.data()
                guard let id = data["id"] as? String,
                      let name = data["name"] as? String,
                      let description = data["description"] as? String,
                      let color = data["color"] as? String,
                      let gender = data["gender"] as? String,
                      let imageUrl = data["image_url"] as? String,
                      let ownerId = data["owner_id"] as? String,
                      let company = data["company"] as? String,
                      let category = data["category"] as? String,
                      let condition = data["condition"] as? String,
                      let dataArr = data["data"] as? [[String: Any]]
                else {
                    completion(.success([]))
                    return
                }
                
                var shoeData: [ShoesDetail] = []
                
                for dict in dataArr {
                    guard let size = dict["size"] as? String,
                          let price = dict["price"] as? Double,
                          let quantity = dict["quantity"] as? Int
                    else {
                        completion(.success([]))
                        return
                    }
                    
                    let shoe = ShoesDetail(size: size, price: Float(price), quantity: quantity)
                    shoeData.append(shoe)
                }
                
                let shoe = Shoes(id: id, name: name, description: description, color: color, gender: gender, condition: condition, imageUrl: imageUrl, data: shoeData, ownerId: ownerId, company: company, category: category)
                shoes.append(shoe)
            }
            
            completion(.success(shoes))
        }
    }
    
    public func getShoeCountForCurrentUser(ownerId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        getAllShoesForCurrentUser(ownerId: ownerId) { result in
            switch result {
                case .success(let shoes):
                    let count = shoes.count
                    completion(.success(count))
                case .failure(let error):
                    completion(.failure(error))
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
    
    /// Get shoes from Database with specific IDs
    public func getShoesWithIDs(ids: [String], completion: @escaping (Result<[Shoes], Error>) -> Void) {
        db.collection("shoes").whereField("id", in: ids).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.success([]))
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
                    completion(.success([]))
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
            
            completion(.success(shoes))
        }
    }

    
    public func getAllShoesByUserID(userID: String, completion: @escaping ([Shoes]?, Error?) -> Void) {
        db.collection("shoes")
            .whereField("owner_id", isEqualTo: userID)
            .getDocuments { (snapshot, error) in
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
    
    public func getAllFilterShoes(searchStr: String, selectedGender: String, selectedColor: String, selectedBrand: String, selectedCondition: String, selectedCategory: String, completion: @escaping ([Shoes]?, Error?) -> Void) {
        
        var query: Query = db.collection("shoes")
        
        if selectedGender != "NONE" {
            query = query.whereField("gender", isEqualTo: selectedGender)
        }
        
        if selectedColor != "None" {
            query = query.whereField("color", isEqualTo: selectedColor)
        }
        
        if selectedBrand != "None" {
            query = query.whereField("company", isEqualTo: selectedBrand)
        }
        
        if selectedCondition != "None" {
            query = query.whereField("condition", isEqualTo: selectedCondition)
        }
        
        if selectedCategory != "None" {
            query = query.whereField("category", isEqualTo: selectedCategory)
        }
        
        query.getDocuments { (snapshot, error) in
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
                if searchStr != "None" {
                    if name.lowercased().contains(searchStr.lowercased()) || company.lowercased() ==  searchStr.lowercased() {
                        shoes.append(shoe)
                    }
                } else {
                    shoes.append(shoe)
                }
            }
            
            completion(shoes, nil)
        }
    }

    
    public func getShoe(withId id: String, completion: @escaping (Shoes?, Error?) -> Void) {
            db.collection("shoes")
                .whereField("id", isEqualTo: id)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }

                    guard let snapshot = snapshot, let document = snapshot.documents.first else {
                        completion(nil, nil)
                        return
                    }

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
                    completion(shoe, nil)
                }
        }
    
    public func getCategoryShoes(withCategory categoryString: String, completion: @escaping ([Shoes]?, Error?) -> Void) {
        db.collection("shoes")
            .whereField("category", isEqualTo: categoryString)
            .getDocuments { (snapshot, error) in
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

// MARK: - Messanger

extension FirestoreManager {
    
    /// Creates a new converstion with target user email and first message sent
    public func createNewConveration(with otherUserEmail: String, name: String, fisrtMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail")?.lowercased() else {
            completion(false)
            return
        }

        let docRef = db.collection("conversations").document(currentEmail)
        docRef.getDocument { [weak self] (document, error) in
            guard error == nil else {
                completion(false)
                return
            }

            let messageDate = fisrtMessage.sentDate
            let dateString = fisrtMessage.sentDate.ISO8601Format()

            var message = ""

            switch fisrtMessage.kind {
                case .text(let messageText):
                    message = messageText
                case .attributedText(_):
                    break
                case .photo(_):
                    message = "Photo"
                case .video(_):
                    message = "Video"
                case .location(_):
                    message = "Location"
                case .emoji(_):
                    break
                case .audio(_):
                    break
                case .contact(_):
                    break
                case .linkPreview(_):
                    break
                case .custom(_):
                    break
            }
            
            let conversationID = "conversation_\(fisrtMessage.messageId)"

            let newConversationData: [String: Any] = [
                "id": conversationID,
                "name": name,
                "other_user_email": otherUserEmail,
                "date": dateString,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ] as [String : Any]
            ]
            
            guard let currentUserName = UserDefaults.standard.string(forKey: "currentUserName") else {
                completion(false)
                return
            }
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationID,
                "name": currentUserName,
                "other_user_email": currentEmail,
                "date": dateString,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ] as [String : Any]
            ]
            // Update recipient user conversation
            
            let recipientRef = self?.db.collection("conversations").document(otherUserEmail)
            recipientRef?.getDocument { (document, error) in
                guard error == nil else {
                    completion(false)
                    return
                }

                var recipientConversations: [[String: Any]]

                if let recipientData = document?.data(),
                    let existingConversations = recipientData["conversations"] as? [[String: Any]] {
                    recipientConversations = existingConversations
                } else {
                    recipientConversations = []
                }

                recipientConversations.append(recipient_newConversationData)

                recipientRef?.setData(["conversations": recipientConversations], merge: true) { error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                }
            }



            // Update current user conversation
            guard let document = document, document.exists else {
                // Create an array with the new conversation object
                let newConversationArray: [[String: Any]] = [newConversationData]

                docRef.setData(["conversations": newConversationArray], merge: true) { [weak self] error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(converationID: conversationID, name: currentUserName, firstMessage: fisrtMessage, completion: completion)
                }
                return
            }

            guard let data = document.data(), var conversations = data["conversations"] as? [[String: Any]] else {
                completion(false)
                return
            }

            conversations.append(newConversationData)

            docRef.setData(["conversations": conversations], merge: true) { [weak self] error in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                self?.finishCreatingConversation(converationID: conversationID, name: currentUserName, firstMessage: fisrtMessage, completion: completion)
            }
        }
    }
    
    private func finishCreatingConversation(converationID: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            completion(false)
            return
        }
        
        let messageDate = firstMessage.sentDate
        let dateString = messageDate.ISO8601Format()
        
        var content = ""

        switch firstMessage.kind {
            case .text(let messageText):
                content = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let urlImage = mediaItem.url?.absoluteString {
                    content = urlImage
                }
                break
            case .video(let mediaItem):
                if let urlImage = mediaItem.url?.absoluteString {
                    content = urlImage
                }
                break
            case .location(let locationItem):
                let location = locationItem.location
                content = "\(location.coordinate.longitude)|\(location.coordinate.latitude)"
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
        }
        
        let message: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": content,
            "date": dateString,
            "sender_email": currentEmail,
            "name": name,
            "is_read": false
        ]
        
        let value: [String: Any] = [
            "messages": [
                message
            ]
        ]
        
        let docRef = db.collection("messages").document(converationID)
        docRef.setData(value) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }


    
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        let conversationRef = db.collection("conversations").document(email.lowercased())
        conversationRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success([]))
                return
            }

            guard let data = snapshot.data(), let conversations = data["conversations"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }

            var allConversations: [Conversation] = []

            for conversation in conversations {
                guard let id = conversation["id"] as? String,
                    let name = conversation["name"] as? String,
                    let dateString = conversation["date"] as? String,
                    let otherUserEmail = conversation["other_user_email"] as? String,
                    let latestMessageDict = conversation["latest_message"] as? [String: Any],
                    let latestMessageDate = latestMessageDict["date"] as? String,
                    let latestMessageText = latestMessageDict["message"] as? String,
                    let latestMessageIsRead = latestMessageDict["is_read"] as? Bool,
                    let dateConversation = DateFormatter.dateFormatter.date(from: dateString) else {
                        continue
                }

                let latestMessage = LatestMessage(date: latestMessageDate, text: latestMessageText, isRead: latestMessageIsRead)
                let conversation = Conversation(id: id, name: name, otherUserEmail: otherUserEmail, date: dateConversation, latestMessage: latestMessage)

                allConversations.append(conversation)
            }

            completion(.success(allConversations))
        }
    }

    
    /// Get all messages for converstion by id
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let messagesRef = db.collection("messages").document(id)
        messagesRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success([]))
                return
            }

            guard let data = snapshot.data(), let messages = data["messages"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }

            var allMessages: [Message] = []

            for message in messages {
                guard let name = message["name"] as? String,
                    let isRead = message["is_read"] as? Bool,
                    let id = message["id"] as? String,
                    let content = message["content"] as? String,
                    let senderEmail = message["sender_email"] as? String,
                    let type = message["type"] as? String,
                    let dateString = message["date"] as? String,
                    let date = DateFormatter.dateFormatter.date(from: dateString) else {
                        print("Could not parse message")
                        continue
                }
                
                var kind: MessageKind = .text(content)
                
                switch type {
                    case "photo":
                        guard let imageUrl = URL(string: content) else {
                            return
                        }
                        let media = Media(url: imageUrl, placeholderImage: UIImage(systemName: "photo")!.withTintColor(.gray, renderingMode: .alwaysOriginal), size: CGSize(width: 300, height: 300))
                        kind = .photo(media)
                    case "video":
                        guard let videoUrl = URL(string: content) else {
                            return
                        }
                        let media = Media(url: videoUrl, placeholderImage: UIImage(systemName: "video.fill")!.withTintColor(.gray, renderingMode: .alwaysOriginal), size: CGSize(width: 300, height: 300))
                        kind = .video(media)
                    case "location":
                        let locationComponents = content.components(separatedBy: "|")
                        guard let long = Double(locationComponents[0]), let latt = Double(locationComponents[1]) else {
                            return
                        }
                        print(long)
                        print(latt)
                        let location = Location(location: CLLocation(latitude: latt, longitude: long), size: CGSize(width: 300, height: 300))
                        kind = .location(location)
                    default:
                        break
                }

                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)

                let message = Message(sender: sender, messageId: id, sentDate: date, kind: kind)
                
                allMessages.append(message)
            }

            completion(.success(allMessages))
        }
    }

    
    /// Send message to current conversation
    public func sendMessage(conversationID: String, email: String, otherUser: IlymaxUser, message: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            completion(false)
            return
        }
        
        guard let currentUserName = UserDefaults.standard.string(forKey: "currentUserName") else {
            completion(false)
            return
        }
        
        
        let currentUser = IlymaxUser(name: currentUserName, emailAddress: currentEmail, profilePictureUrl: nil)
        
        let messageDate = message.sentDate
        let dateString = DateFormatter.dateFormatter.string(from: messageDate)
        
        var content = ""
        
        switch message.kind {
            case .text(let messageText):
                content = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let urlImage = mediaItem.url?.absoluteString {
                    content = urlImage
                }
                break
            case .video(let mediaItem):
                if let urlImage = mediaItem.url?.absoluteString {
                    content = urlImage
                }
                break
            case .location(let locationItem):
                let location = locationItem.location
                content = "\(location.coordinate.longitude)|\(location.coordinate.latitude)"
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
        }
        
        let message: [String: Any] = [
            "id": message.messageId,
            "type": message.kind.messageKindString,
            "content": content,
            "date": dateString,
            "sender_email": currentEmail,
            "name": currentUserName,
            "is_read": false
        ]
        
        let docRef = db.collection("messages").document(conversationID)
        docRef.updateData([
            "messages": FieldValue.arrayUnion([message])
        ]) { [weak self] error in
            if error != nil {
                completion(false)
            } else {
                self?.updateConversationLatestMessage(conversationId: conversationID, email: currentEmail, otherUser: otherUser, latestMessage: message) { updated in
                    if updated {
                        self?.updateConversationLatestMessage(conversationId: conversationID, email: email, otherUser: currentUser, latestMessage: message) { updated in
                            if updated {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    public func updateConversationLatestMessage(conversationId: String, email: String, otherUser: IlymaxUser, latestMessage: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let dateString = latestMessage["date"], let content = latestMessage["content"] else {
            completion(false)
            return
        }
        
        let latestMessageData: [String: Any] = [
            "date": dateString,
            "message": content,
            "is_read": false
        ]
        
        let conversationRef = db.collection("conversations").document(email)
        conversationRef.getDocument { (document, error) in
            guard error == nil else {
                completion(false)
                return
            }
            if let conversationData = document?.data(),
               var existingConversations = conversationData["conversations"] as? [[String: Any]] {
                for (index, conversation) in existingConversations.enumerated() {
                    if let id = conversation["id"] as? String,
                       id == conversationId {
                        existingConversations[index]["latest_message"] = latestMessageData
                        conversationRef.setData(["conversations": existingConversations], merge: true) { error in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        }
                        return
                    }
                }
                // Conversation with the given ID not found, so create a new one and append to existing conversations
                let newConversation: [String: Any] = [
                    "id": conversationId,
                    "latest_message": latestMessageData,
                    "name": otherUser.name,
                    "other_user_email": otherUser.emailAddress,
                    "date": latestMessageData["date"]
                ]
                existingConversations.append(newConversation)
                conversationRef.setData(["conversations": existingConversations], merge: true) { error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                // User has no existing conversations, so create a new one
                let newConversation: [String: Any] = [
                    "id": conversationId,
                    "latest_message": latestMessageData,
                    "name": otherUser.name,
                    "other_user_email": otherUser.emailAddress,
                    "date": latestMessageData["date"]
                ]
                conversationRef.setData(["conversations": [newConversation]], merge: true) { error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }

    
    private func getConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        let conversationRef = db.collection("conversations").document(email.lowercased())
        
        conversationRef.getDocument { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success([]))
                return
            }
            
            guard let data = snapshot.data(), let conversations = data["conversations"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }
            
            var allConversations: [Conversation] = []
            
            for conversation in conversations {
                guard let id = conversation["id"] as? String,
                      let name = conversation["name"] as? String,
                      let dateString = conversation["date"] as? String,
                      let otherUserEmail = conversation["other_user_email"] as? String,
                      let latestMessageDict = conversation["latest_message"] as? [String: Any],
                      let latestMessageDate = latestMessageDict["date"] as? String,
                      let latestMessageText = latestMessageDict["message"] as? String,
                      let latestMessageIsRead = latestMessageDict["is_read"] as? Bool,
                      let dateConversation = DateFormatter.dateFormatter.date(from: dateString) else {
                    continue
                }
                let latestMessage = LatestMessage(date: latestMessageDate, text: latestMessageText, isRead: latestMessageIsRead)
                let conversation = Conversation(id: id, name: name, otherUserEmail: otherUserEmail, date: dateConversation, latestMessage: latestMessage)
                
                allConversations.append(conversation)
            }
            
            completion(.success(allConversations))
        }
    }

    
    public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            completion(false)
            return
        }
        
        getConversations(for: currentEmail) { [weak self] result in
            switch result {
                case .success(var conversations):
                    conversations.removeAll(where: { $0.id == conversationId })
                    self?.updateConversations(for: currentEmail, with: conversations) { updated in
                        completion(updated)
                    }
                case .failure(_):
                    completion(false)
            }
        }
    }

    
    public func updateConversations(for email: String, with conversations: [Conversation], completion: @escaping (Bool) -> Void) {
        let conversationRef = db.collection("conversations").document(email.lowercased())
        
        // Convert the array of conversations to an array of dictionaries
        let conversationsData = conversations.map { conversation -> [String: Any] in
            let latestMessage = conversation.latestMessage
            let conversationData: [String: Any] = [
                "id": conversation.id,
                "name": conversation.name,
                "other_user_email": conversation.otherUserEmail,
                "date": conversation.date.ISO8601Format(),
                "latest_message": [
                    "date": latestMessage.date,
                    "message": latestMessage.text,
                    "is_read": latestMessage.isRead
                ] as [String : Any]
            ]
            return conversationData
        }
        
        conversationRef.setData(["conversations": conversationsData]) { error in
            if let error = error {
                print("Error updating conversations: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    public func getConversation(with targetRecipientEmail: String, completion: @escaping (Result<Conversation, Error>) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            completion(.failure(NSError()))
            return
        }
        
        getConversations(for: targetRecipientEmail) { result in
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let conversations):
                    if let conversationBetween2Users = conversations.first(where: {
                        $0.otherUserEmail == currentEmail
                    }) {
                        completion(.success(conversationBetween2Users))
                    } else {
                        completion(.failure(NSError()))
                    }
            }
        }
    }


}


// MARK: - Reviews managment

extension FirestoreManager {
    
    
    /// Insert new review
    func insertReview(_ review: IlymaxReview, completion: @escaping (Result<String, Error>) -> Void) {
        var ref: DocumentReference? = nil
        
        let data: [String: Any] = [
            "text": review.text,
            "rate": review.rate,
            "author_id": review.authorId,
            "shoes_id": review.shoesId,
            "date": DateFormatter.dateFormatter.string(from: review.date)
        ]
        
        ref = db.collection(IlymaxReview.collectionName).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(ref!.documentID))
            }
        }
    }
    
    
    /// Get reviews by shoesId
    func getReviewsByShoesId(_ shoesId: String, completion: @escaping (Result<[IlymaxReview], Error>) -> Void) {
        db.collection(IlymaxReview.collectionName)
            .whereField("shoes_id", isEqualTo: shoesId)
            .getDocuments { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NSError(domain: "Firestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve reviews."])))
                    }
                    return
                }
                var reviews: [IlymaxReview] = []
                for document in querySnapshot.documents {
                    let data = document.data()
                    guard let text = data["text"] as? String,
                          let rate = data["rate"] as? Int,
                          let authorId = data["author_id"] as? String,
                          let shoesId = data["shoes_id"] as? String,
                          let dateString = data["date"] as? String,
                          let date = DateFormatter.dateFormatter.date(from: dateString) else {
                        continue
                    }
                    let review = IlymaxReview(text: text, rate: rate, authorId: authorId, shoesId: shoesId, date: date)
                    reviews.append(review)
                }
                completion(.success(reviews))
        }
    }
    
    
    /// Count mean rate of reviews for shoesId
    func countMeanRateOfReviewsForShoesId(_ shoesId: String, completion: @escaping (Result<Double, Error>) -> Void) {
        db.collection(IlymaxReview.collectionName)
            .whereField("shoes_id", isEqualTo: shoesId)
            .getDocuments { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NSError(domain: "Firestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve reviews."])))
                    }
                    return
                }
                var totalRate = 0
                var count = 0
                for document in querySnapshot.documents {
                    let data = document.data()
                    guard let rate = data["rate"] as? Int else {
                        continue
                    }
                    totalRate += rate
                    count += 1
                }
                if count > 0 {
                    let meanRate = Double(totalRate) / Double(count)
                    completion(.success(meanRate))
                } else {
                    completion(.success(0))
                }
        }
    }
}


// MARK: - Cart managment

extension FirestoreManager {
    
    
    func addItemToCart(userID: String, item: IlymaxCartItem, completion: @escaping (Bool) -> ()) {
        let data: [String: Any] = [
            "id": item.id,
            "name": item.name,
            "description": item.description,
            "color": item.color,
            "gender": item.gender,
            "condition": item.condition,
            "imageUrl": item.imageUrl,
            "data": [
                "size": item.data.size,
                "price": item.data.price,
                "quantity": item.data.quantity
            ] as [String : Any],
            "ownerId": item.ownerId,
            "company": item.company,
            "category": item.category,
        ]
        
        let cartRef = db.collection(IlymaxCartItem.collectionName).document(userID)
        cartRef.getDocument { (snapshot, error) in
            if let error = error {
                print("Error getting cart items: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                cartRef.updateData([
                    "items": FieldValue.arrayUnion([data])
                ]) { (error) in
                    if let error = error {
                        print("Error adding item to cart: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Item added to cart")
                        completion(true)
                    }
                }
            } else {
                cartRef.setData([
                    "items": [data]
                ]) { (error) in
                    if let error = error {
                        print("Error creating cart items document: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Cart items document created with item")
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    func getCartItemsListener(for userId: String, completion: @escaping (Result<[IlymaxCartItem], Error>) -> Void) {
        let cartRef = db.collection(IlymaxCartItem.collectionName).document(userId)
        cartRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success([]))
                return
            }
            
            guard let data = snapshot.data(), let items = data["items"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }
            
            var cartItems: [IlymaxCartItem] = []
            
            for item in items {
                guard
                    let id = item["id"] as? String,
                    let name = item["name"] as? String,
                    let description = item["description"] as? String,
                    let color = item["color"] as? String,
                    let gender = item["gender"] as? String,
                    let condition = item["condition"] as? String,
                    let imageUrl = item["imageUrl"] as? String,
                    let ownerId = item["ownerId"] as? String,
                    let company = item["company"] as? String,
                    let category = item["category"] as? String,
                    let shoesData = item["data"] as? [String : Any],
                    let size = shoesData["size"] as? String,
                    let price = shoesData["price"] as? Float,
                    let quantity = shoesData["quantity"] as? Int
                else {
                    continue
                }
                
                let shoesDetail = ShoesDetail(size: size, price: price, quantity: quantity)
                let cartItem = IlymaxCartItem(id: id, name: name, description: description, color: color, gender: gender, condition: condition, imageUrl: imageUrl, data: shoesDetail, ownerId: ownerId, company: company, category: category)
                
                cartItems.append(cartItem)
            }
            
            completion(.success(cartItems))
        }
    }
    
    private func getCartItems(for userId: String, completion: @escaping (Result<[IlymaxCartItem], Error>) -> Void) {
        let cartRef = db.collection(IlymaxCartItem.collectionName).document(userId)
        cartRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success([]))
                return
            }
            
            guard let data = snapshot.data(), let items = data["items"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }
            
            var cartItems: [IlymaxCartItem] = []
            
            for item in items {
                guard
                    let id = item["id"] as? String,
                    let name = item["name"] as? String,
                    let description = item["description"] as? String,
                    let color = item["color"] as? String,
                    let gender = item["gender"] as? String,
                    let condition = item["condition"] as? String,
                    let imageUrl = item["imageUrl"] as? String,
                    let ownerId = item["ownerId"] as? String,
                    let company = item["company"] as? String,
                    let category = item["category"] as? String,
                    let shoesData = item["data"] as? [String : Any],
                    let size = shoesData["size"] as? String,
                    let price = shoesData["price"] as? Float,
                    let quantity = shoesData["quantity"] as? Int
                else {
                    continue
                }
                
                let shoesDetail = ShoesDetail(size: size, price: price, quantity: quantity)
                let cartItem = IlymaxCartItem(id: id, name: name, description: description, color: color, gender: gender, condition: condition, imageUrl: imageUrl, data: shoesDetail, ownerId: ownerId, company: company, category: category)
                
                cartItems.append(cartItem)
            }
            
            completion(.success(cartItems))
        }
    }

    
    
    func deleteCartItem(userID: String, itemID: String, size: String, completion: @escaping (Bool) -> ()) {
        getCartItems(for: userID) { [weak self] result in
            
            switch result {
                case .failure(let error):
                    print(error)
                    completion(false)
                case .success(var cartItems):
                    cartItems = cartItems.filter { $0.id != itemID || $0.data.size != size }
                    let cartRef = self!.db.collection(IlymaxCartItem.collectionName).document(userID)
                    cartRef.updateData([
                        "items": cartItems.map { item in
                            return [
                                "id": item.id,
                                "name": item.name,
                                "description": item.description,
                                "color": item.color,
                                "gender": item.gender,
                                "condition": item.condition,
                                "imageUrl": item.imageUrl,
                                "data": [
                                    "size": item.data.size,
                                    "price": item.data.price,
                                    "quantity": item.data.quantity
                                ] as [String : Any],
                                "ownerId": item.ownerId,
                                "company": item.company,
                                "category": item.category,
                            ]
                        }
                    ]) { error in
                        if let error = error {
                            print("Error deleting item from cart: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Item deleted from cart")
                            completion(true)
                        }
                    }
            }
        }
    }
    
    func deleteCart(userID: String, completion: @escaping (Bool) -> ()) {
        let cartRef = db.collection(IlymaxCartItem.collectionName).document(userID)
        cartRef.delete { error in
            if let error = error {
                print("Error deleting cart: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Cart deleted")
                completion(true)
            }
        }
    }
}

// MARK: - Address managment

extension FirestoreManager {
    
    
    func addAddressFor(userID: String, address: IlymaxAddress, completion: @escaping (Bool) -> ()) {
        let data: [String: Any] = [
            "fullName": address.fullName,
            "address": address.address,
            "zipcode": address.zipcode,
            "country": address.country,
            "city": address.city,
            "isDefault": address.isDefault
        ]
        
        let cartRef = db.collection(IlymaxAddress.collectionName).document(userID)
        cartRef.getDocument { (snapshot, error) in
            if let error = error {
                print("Error getting cart items: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                cartRef.updateData([
                    "addresses": FieldValue.arrayUnion([data])
                ]) { (error) in
                    if let error = error {
                        print("Error adding address: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Address added")
                        completion(true)
                    }
                }
            } else {
                cartRef.setData([
                    "addresses": [data]
                ]) { (error) in
                    if let error = error {
                        print("Error creating Addresses document: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Addresses document created with item")
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    func getAddressesListener(for userId: String, completion: @escaping (Result<[IlymaxAddress], Error>) -> Void) {
        let cartRef = db.collection(IlymaxAddress.collectionName).document(userId)
        cartRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success([]))
                return
            }
            
            guard let data = snapshot.data(), let items = data["addresses"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }
            
            var addresses: [IlymaxAddress] = []
            
            for item in items {
                guard
                    let fullName = item["fullName"] as? String,
                    let address = item["address"] as? String,
                    let zipcode = item["zipcode"] as? Int,
                    let country = item["country"] as? String,
                    let city = item["city"] as? String,
                    let isDefault = item["isDefault"] as? Bool
                else {
                    continue
                }
                
                let tempAddress = IlymaxAddress(fullName: fullName, address: address, zipcode: zipcode, country: country, city: city, isDefault: isDefault)
                
                addresses.append(tempAddress)
            }
            
            completion(.success(addresses))
        }
    }
    
    func getAddressCount(for userId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let cartRef = db.collection(IlymaxAddress.collectionName).document(userId)
        cartRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success(0))
                return
            }
            
            guard let data = snapshot.data(), let addresses = data["addresses"] as? [[String: Any]] else {
                completion(.success(0))
                return
            }
            
            completion(.success(addresses.count))
        }
    }
    
    func replaceAddressesFor(userID: String, addresses: [IlymaxAddress], completion: @escaping (Bool) -> ()) {
        let data: [[String: Any]] = addresses.map { address in
            return [
                "fullName": address.fullName,
                "address": address.address,
                "zipcode": address.zipcode,
                "country": address.country,
                "city": address.city,
                "isDefault": address.isDefault
            ]
        }
        
        let cartRef = db.collection(IlymaxAddress.collectionName).document(userID)
        cartRef.setData([
            "addresses": data
        ]) { (error) in
            if let error = error {
                print("Error replacing addresses: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Addresses replaced")
                completion(true)
            }
        }
    }
    
    func getDefaultAddress(for userId: String, completion: @escaping (Result<IlymaxAddress?, Error>) -> Void) {
        let cartRef = db.collection(IlymaxAddress.collectionName).document(userId)
        cartRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                completion(.success(nil))
                return
            }
            
            guard let data = snapshot.data(), let addresses = data["addresses"] as? [[String: Any]] else {
                completion(.success(nil))
                return
            }
            
            var defaultAddress: IlymaxAddress?
            
            for item in addresses {
                guard
                    let fullName = item["fullName"] as? String,
                    let address = item["address"] as? String,
                    let zipcode = item["zipcode"] as? Int,
                    let country = item["country"] as? String,
                    let city = item["city"] as? String,
                    let isDefault = item["isDefault"] as? Bool
                else {
                    continue
                }
                
                let tempAddress = IlymaxAddress(fullName: fullName, address: address, zipcode: zipcode, country: country, city: city, isDefault: isDefault)
                
                if isDefault {
                    defaultAddress = tempAddress
                    break
                }
            }
            
            completion(.success(defaultAddress))
        }
    }
}


// MARK: - Orders managment
extension FirestoreManager {
    
    
    func addOrder(order: IlymaxOrder, completion: @escaping (Bool) -> ()) {
        let data: [String: Any] = [
            "id": order.id,
            "date": order.date.ISO8601Format(),
            "status": order.status,
            "customerId": order.customerId,
            "items": order.items.map { item in
                return [
                    "id": item.id,
                    "name": item.name,
                    "description": item.description,
                    "color": item.color,
                    "gender": item.gender,
                    "condition": item.condition,
                    "imageUrl": item.imageUrl,
                    "data": [
                        "size": item.data.size,
                        "price": item.data.price,
                        "quantity": item.data.quantity
                    ] as [String : Any],
                    "ownerId": item.ownerId,
                    "company": item.company,
                    "category": item.category
                ] as [String : Any]
            },
            "address": [
                "fullName": order.address.fullName,
                "address": order.address.address,
                "zipcode": order.address.zipcode,
                "country": order.address.country,
                "city": order.address.city,
                "isDefault": order.address.isDefault
            ] as [String : Any]
        ]
        
        let orderRef = db.collection(IlymaxOrder.collectionName).document()
        orderRef.setData(data) { (error) in
            if let error = error {
                print("Error adding order: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Order added")
                completion(true)
            }
        }
    }

    
    
    func getAllOrdersFor(userID: String) async throws -> [IlymaxOrder] {
        let ordersRef = db.collection(IlymaxOrder.collectionName)
        let query = ordersRef.whereField("customerId", isEqualTo: userID)
        
        do {
            let querySnapshot = try await query.getDocuments()
            var orders: [IlymaxOrder] = []
            
            for document in querySnapshot.documents {
                let orderData = document.data()
                guard let id = orderData["id"] as? String,
                      let dateString = orderData["date"] as? String,
                      let status = orderData["status"] as? String,
                      let customerId = orderData["customerId"] as? String,
                      let date = DateFormatter.dateFormatter.date(from: dateString),
                      let itemsData = orderData["items"] as? [[String: Any]],
                      let addressData = orderData["address"] as? [String: Any],
                      let fullName = addressData["fullName"] as? String,
                      let _address = addressData["address"] as? String,
                      let zipcode = addressData["zipcode"] as? Int,
                      let country = addressData["country"] as? String,
                      let city = addressData["city"] as? String,
                      let isDefault = addressData["isDefault"] as? Bool
                else {
                    continue
                }
                
                var items: [IlymaxCartItem] = []
                
                for itemData in itemsData {
                    guard let itemId = itemData["id"] as? String,
                          let itemName = itemData["name"] as? String,
                          let itemDescription = itemData["description"] as? String,
                          let itemColor = itemData["color"] as? String,
                          let itemGender = itemData["gender"] as? String,
                          let itemCondition = itemData["condition"] as? String,
                          let itemImageUrl = itemData["imageUrl"] as? String,
                          let itemDataDict = itemData["data"] as? [String: Any],
                          let itemSize = itemDataDict["size"] as? String,
                          let itemPrice = itemDataDict["price"] as? Float,
                          let itemQuantity = itemDataDict["quantity"] as? Int,
                          let ownerId = itemData["ownerId"] as? String,
                          let company = itemData["company"] as? String,
                          let category = itemData["category"] as? String
                    else {
                        continue
                    }
                    
                    let item = IlymaxCartItem(
                        id: itemId,
                        name: itemName,
                        description: itemDescription,
                        color: itemColor,
                        gender: itemGender,
                        condition: itemCondition,
                        imageUrl: itemImageUrl,
                        data: ShoesDetail(size: itemSize, price: itemPrice, quantity: itemQuantity),
                        ownerId: ownerId,
                        company: company,
                        category: category
                    )
                    items.append(item)
                }
                
                let address = IlymaxAddress(
                    fullName: fullName,
                    address: _address,
                    zipcode: zipcode,
                    country: country,
                    city: city,
                    isDefault: isDefault
                )
                
                let order = IlymaxOrder(id: id, date: date, status: status, customerId: customerId, items: items, address: address)
                orders.append(order)
            }
            
            return orders
        } catch {
            throw error
        }
    }
    
    func getCountOrderForUser(with id: String, completion: @escaping (Int) -> Void) {
        let ordersRef = db.collection(IlymaxOrder.collectionName)
        let query = ordersRef.whereField("customerId", isEqualTo: id)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting orders: \(error.localizedDescription)")
                completion(0)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                completion(0)
                return
            }
            
            let count = querySnapshot.documents.count
            completion(count)
        }
    }
}

