//
//  ChatService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.04.2023.
//

import Foundation

class ChatService {
    
    
    func createNewConveration(with: String, name: String, fisrtMessage: Message, comletion: @escaping (Bool) -> Void) {
        FirestoreManager.shared.createNewConveration(with: with, name: name, fisrtMessage: fisrtMessage) { result in
            comletion(result)
        }
    }
    
    func listenForMessages(for id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        FirestoreManager.shared.getAllMessagesForConversation(with: id) { result in
            completion(result)
        }
    }
    
    func sendMessage(to: String, email: String, message: Message, completion: @escaping (Bool) -> Void)  {
        FirestoreManager.shared.sendMessage(conversationID: to, email: email, message: message) { result in
            completion(result)
        }
    }
}
