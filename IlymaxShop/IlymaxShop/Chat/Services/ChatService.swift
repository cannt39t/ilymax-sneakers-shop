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
    
    func listenForMessages(for id: String, completion: @escaping ()) {
        FirestoreManager.shared.getAllMessagesForConversation(with: id) { result in
            <#code#>
        }
    }
}
