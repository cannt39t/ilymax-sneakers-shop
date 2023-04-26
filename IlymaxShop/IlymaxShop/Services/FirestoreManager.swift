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
                    let shoe = Shoes(name: name, description: description, color: color, gender: gender, condition: condition, imageUrl: imageUrl, data: shoeData, ownerId: ownerId, company: company, category: category)
                    completion(shoe, nil)
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
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
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
            let dateString = DateFormatter.dateFormatter.string(from: messageDate)

            var message = ""

            switch fisrtMessage.kind {
                case .text(let messageText):
                    message = messageText
                case .attributedText(_):
                    break
                case .photo(_):
                    break
                case .video(_):
                    break
                case .location(_):
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
            
            let conversationID = "conversation_\(fisrtMessage.messageId)"

            let newConversationData: [String: Any] = [
                "id": conversationID,
                "name": name,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            guard let currentUserName = UserDefaults.standard.string(forKey: "currentUserName") else {
                completion(false)
                return
            }
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationID,
                "name": currentUserName,
                "other_user_email": currentEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
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
        let dateString = DateFormatter.dateFormatter.string(from: messageDate)
        
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
            case .video(_):
                break
            case .location(_):
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
                    let otherUserEmail = conversation["other_user_email"] as? String,
                    let latestMessageDict = conversation["latest_message"] as? [String: Any],
                    let latestMessageDate = latestMessageDict["date"] as? String,
                    let latestMessageText = latestMessageDict["message"] as? String,
                    let latestMessageIsRead = latestMessageDict["is_read"] as? Bool else {
                        continue
                }

                let latestMessage = LatestMessage(date: latestMessageDate, text: latestMessageText, isRead: latestMessageIsRead)
                let conversation = Conversation(id: id, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessage)

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
                        continue
                }
                
                var kind: MessageKind = .text(content)
                
                switch type {
                    case "photo":
                        guard let imageUrl = URL(string: content) else {
                            return
                        }
                        let media = Media(url: imageUrl, placeholderImage: UIImage(systemName: "photo")!, size: CGSize(width: 300, height: 300))
                        kind = .photo(media)
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
    public func sendMessage(conversationID: String, email: String, message: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            completion(false)
            return
        }
        
        guard let currentUserName = UserDefaults.standard.string(forKey: "currentUserName") else {
            completion(false)
            return
        }
        
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
            case .video(_):
                break
            case .location(_):
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
                self?.updateConversationLatestMessage(conversationId: conversationID, email: currentEmail, latestMessage: message) { updated in
                    if updated {
                        self?.updateConversationLatestMessage(conversationId: conversationID, email: email, latestMessage: message) { updated in
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
    
    public func updateConversationLatestMessage(conversationId: String, email: String, latestMessage: [String: Any], completion: @escaping (Bool) -> Void) {
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
            }
            completion(false)
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


