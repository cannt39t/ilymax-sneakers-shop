//
//  Shoes.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 02.04.2023.
//

import Foundation

struct Shoes {
    let name: String
    let description: String
    let color: String
    let gender: String
    let imageUrl: String?
    let data: [ShoesDetail]
    
    let ownerId: String
    let company: String
    let category: String
    
    var sizes: [String] {
        data.map { String($0.size) }.sorted()
    }
    
    var lowestPrice: Float {
        data.map { Float($0.price) }.sorted()[0]
    }
}

struct ShoesDetail {
    let size: String
    let price: Float
    let quantity: Int
}
