//
//  DatabaseManager.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 28.03.2023.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

// MARK: - Sending messages / conversations

extension DatabaseManager {
    
    /*
     
     "asdfasfds" {
        "messages": [
            {
                "id": String
                "type": text, photo, video and etc.
                "content": ???
                "date": Date()
                "sender_email": String,
                "isRead": true/false
            }
        ]
     
         converations => [
            [
                "converasation_id": ID,
                "other_user_email": email,
                "latest_message": => [
                    "date": Date()
                    "latest_message": Text
                    "is_read": true/false
                ]
            ]
         ]
     }
     
     
     */
    
    /// Creates a new converstion with target user email and first message sent
    public func createNewConveration(with otherUserEmail: String, fisrtMessage: Message, comletion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            return
        }
        let safeEmail = Security.getSafeEmail(email: currentEmail)
        
        let ref = database.child(safeEmail)
        
        ref.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                comletion(false)
                print("User not found")
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
            
            let newConverstionData = [
                "id": "conversation_\(fisrtMessage.messageId)",
                "other_user_email": "email",
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            if var converations = userNode["conversations"] as? [[String: Any]] {
                // converstions array exists for current user
                // you should append
                
                converations.append(newConverstionData)
                
                userNode["converations"] = converations
                
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        comletion(false)
                        return
                    }
                    comletion(true)
                }
                
            } else {
                // conversation array does not exist
                // creaate array of users converstions
                userNode["converations"] = [
                    newConverstionData
                ]
                
                ref.setValue(userNode) { error, _ in
                    guard error == nil else {
                        comletion(false)
                        return
                    }
                    comletion(true)
                }
            }
            
        }
    }
    
    /// Fethes and returns all converations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    /// Get all messages for converstion by id
    public func getAllMessagesForConversation(with id: String, completion: (Result<String, Error>) -> Void) {
        
    }
    
    /// Send message to current conversation
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
}
