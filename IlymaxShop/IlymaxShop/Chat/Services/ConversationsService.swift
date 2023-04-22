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
        
        FirestoreManager.shared.getAllConversations(for: email) {  result in
            completion(result)
        }
    }
    
}
