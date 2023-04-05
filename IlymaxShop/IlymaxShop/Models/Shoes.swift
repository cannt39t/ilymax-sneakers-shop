//
//  Shoes.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 02.04.2023.
//

import Foundation

struct Shoes {
    var name: String
    var description: String
    var color: String
    var gender: String
    var condition: String
    var imageUrl: String?
    var data: [ShoesDetail]
    
    var ownerId: String
    var company: String
    var category: String
    
    var sizes: [String] {
        data.map { String($0.size) }.sorted()
    }
    
    var lowestPrice: Float {
        data.map { Float($0.price) }.sorted()[0]
    }
}

struct ShoesDetail {
    var size: String
    var price: Float
    var quantity: Int
}
