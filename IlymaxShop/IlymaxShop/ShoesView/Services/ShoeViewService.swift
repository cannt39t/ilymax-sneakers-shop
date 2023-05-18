//
//  ShoeViewService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit
import SDWebImage

class ShoeViewService {
    
    
    func getReviewsByShoesId(_ shoesId: String, completion: @escaping (Result<[IlymaxReview], Error>) -> Void) {
        FirestoreManager.shared.getReviewsByShoesId(shoesId) { result in
            completion(result)
        }
    }
    
    func getUser(userID: String, completion: @escaping (IlymaxUser?) -> Void) {
        FirestoreManager.shared.getUser(with: userID) { user in
            if let user = user {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func addItemToCart(userID: String, item: IlymaxCartItem) {
        FirestoreManager.shared.addItemToCart(userID: userID, item: item) { success in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
    
    func getAllShoesByUserID(userID: String, completion: @escaping (([Shoes]) -> Void)){
        FirestoreManager.shared.getAllShoesByUserID(userID: userID) { shoes, error in
            if let error {
                print(error)
                completion([])
                return
            }
            completion(shoes ?? [])
        }
    }
}
