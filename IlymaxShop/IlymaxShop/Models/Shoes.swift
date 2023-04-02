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
    let imageUrl: String
    let data: [ShoesDetail]
    
    let ownerId: String
    let company: String
    let category: String
}

struct ShoesDetail {
    let size: String
    let price: Float
    let quanity: Int
}
