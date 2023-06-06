//
//  CartService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import Foundation
import Combine
import FirebaseAuth

class CartService {
    public func getProducts(userID: String, completion: @escaping (([IlymaxCartItem]) -> Void)) {
        FirestoreManager.shared.getCartItemsListener(for: userID) { result in
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
    
    public func getShoe (shoeId: String, completion: @escaping ((Shoes?, Error?) -> Void)) {
        FirestoreManager.shared.getShoe(withId: shoeId) { shoe, error in
            completion(shoe, error)
        }
    }
    
    public func getDefaultAddress(completion: @escaping (Result<IlymaxAddress?, Error>) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getDefaultAddress(for: currentUserId) { result in
            completion(result)
        }
    }
    
    public func createOrder(items: [IlymaxCartItem], address: IlymaxAddress, completion: @escaping (Bool) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        let order = IlymaxOrder(id: "238562312", date: Date(), status: "Processing", customerId: currentUserId, items: items, address: address)
        FirestoreManager.shared.addOrder(order: order) { result in
            completion(result)
        }
    }
    
    public func deleteCart(completion: @escaping (Bool) -> Void) {
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.deleteCart(userID: currentUserId) { result in
            completion(result)
        }
    }
}
