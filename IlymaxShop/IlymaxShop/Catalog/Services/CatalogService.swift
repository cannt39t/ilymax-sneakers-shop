//
//  CatalogService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import Foundation

class CatalogService {
    
    public func getAllPromotions(completion: @escaping (([Promotion]) -> Void)) {
        FirestoreManager.shared.getAllPromotions { promotions in
            completion(promotions)
        }
    }
    
    public func getAllCategories(completion: @escaping (([IlymaxCategory]) -> Void)) {
        FirestoreManager.shared.getAllCategories { categories in
            completion(categories)
        }
    }
    
    public func getPopularShoes(completion: @escaping (([Shoes]) -> Void)) {
        FirestoreManager.shared.getAllShoes { shoes, error in
            if let error {
                print(error)
                completion([])
                return
            }
            completion(shoes ?? [])
        }
    }
    
}
