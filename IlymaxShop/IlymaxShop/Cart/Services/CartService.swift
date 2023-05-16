//
//  CartService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import Foundation
import Combine

class CartService {
    public func getProducts(userID: String, completion: @escaping (([IlymaxCartItem]) -> Void)) {

        FirestoreManager.shared.getCartItems(for: userID) { result in
            switch result {
            case .success(let cartItems):
                completion(cartItems)
            
            case .failure(let error):
                print(error)
                completion([])
         }
        }
    }
    
    func delete(userID: String, itemId: String, size: String){
        FirestoreManager.shared.deleteCartItem(userID: userID, itemID: itemId, size: size) { success in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
    
    public func getShoe (shoeId: String, completion: @escaping ((Shoes) -> Void)) {
        FirestoreManager.shared.getShoe(withId: shoeId){ shoe, error in
            if let error {
                print(error)
                completion(Shoes(name: "", description: "", color: "", gender: "", condition: "", data: [], ownerId: "", company: "", category: ""))
                return
            }
            completion(shoe ?? Shoes(name: "", description: "", color: "", gender: "", condition: "", data: [], ownerId: "", company: "", category: ""))
        }
    }
}
