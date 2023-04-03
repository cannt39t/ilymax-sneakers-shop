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
    
}
