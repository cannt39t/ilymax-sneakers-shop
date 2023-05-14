//
//  IlymaxCartItem.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 14.05.2023.
//

import Foundation

struct IlymaxCartItem: FirestoreCollectionProtocol {
    
    static var collectionName: String = "carts"
    
    var id: String
    var name: String
    var description: String
    var color: String
    var gender: String
    var condition: String
    var imageUrl: String
    var data: ShoesDetail
    var ownerId: String
    var company: String
    var category: String
    
}
