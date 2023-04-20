//
//  CartService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import Foundation
import Combine

class CartService {
    public func getProducts(completion: @escaping (([Shoes]) -> Void)) {
        FirestoreManager.shared.getAllShoes { shoes, error in
            if let error {
                print(error)
                completion([])
                return
            }
            completion(shoes ?? [])
        }
    }
    
    func deleteByID(id: String){
        
    }
}
