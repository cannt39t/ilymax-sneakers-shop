//
//  ChatService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.04.2023.
//

import Foundation

class ChatService {
    
    
    func createNewConveration(with: String, fisrtMessage: Message, comletion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.createNewConveration(with: with, fisrtMessage: fisrtMessage) { result in
            comletion(result)
        }
    }
}
