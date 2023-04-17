//
//  NewConversationService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import Foundation

class NewConversationService {
    
    func getUsers(completion: @escaping ([IlymaxUser]) -> Void) {
        FirestoreManager.shared.getUsersExceptCurrent { users in
            completion(users)
        }
    }
    
}
