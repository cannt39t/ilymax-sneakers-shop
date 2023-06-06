//
//  OrdersService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation
import FirebaseAuth


class OrdersService {
    
    func getAllOrdersFor() async throws -> [IlymaxOrder] {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        return try await FirestoreManager.shared.getAllOrdersFor(userID: currentUserId)
    }
    
}
