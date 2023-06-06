//
//  ListSalesService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation
import FirebaseAuth

class ListSalesService {
    
    func getSaleList(completion: @escaping (Result<[Shoes], Error>) -> Void) {
        let userId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getAllShoesForCurrentUser(ownerId: userId) { result in
            completion(result)
        }
    }
    
}
