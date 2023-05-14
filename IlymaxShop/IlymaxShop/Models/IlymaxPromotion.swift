//
//  Promotion.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 02.04.2023.
//

import Foundation

struct IlymaxPromotion: FirestoreCollectionProtocol {
    
    static var collectionName: String = "promotions"
    
    
    let name: String
    let imageUrl: String
    let shoesIds: [String]
    
}

