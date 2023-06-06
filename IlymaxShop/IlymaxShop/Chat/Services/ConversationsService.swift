//
//  ConversationsService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import Foundation

class ConversationsService {
    
    func startListeningForConversations(completion: @escaping (Result<[Conversation], Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            return
        }
        print(email)
        FirestoreManager.shared.getAllConversations(for: email) {  result in
            completion(result)
        }
    }
    
    func deleteConversation(coversationId: String, completion: @escaping (Bool) -> Void) {
        FirestoreManager.shared.deleteConversation(conversationId: coversationId) { result in
            completion(result)
        }
    }
    
}
