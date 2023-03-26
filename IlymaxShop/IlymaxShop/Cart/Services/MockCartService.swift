//
//  MockCartService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import Foundation
import Combine

class MockCartService: CartService {
    
    private var products: [Product] = [
        Product(id: 1, name: "Adidas", description: "https://myreact.ru/wp-content/uploads/2023/02/duramo_10_shoes_black_gw8336_01_standard.jpg", company: .Adidas, gender: .MAN, color: .Black, category: .Sneakers, condition: .NEW, size: 9, price: 120.00),
        Product(id: 2, name: "Adidas", description: "https://myreact.ru/wp-content/uploads/2023/02/superstar_shoes_white_fv3284_01_standard.jpg", company: .Adidas, gender: .MAN, color: .Black, category: .Sneakers, condition: .NEW, size: 9, price: 120.00),
        Product(id: 3, name: "Adidas", description: "https://assets.adidas.com/images/w_383,h_383,f_auto,q_auto,fl_lossy,c_fill,g_auto/2ca0089986704cfdad3da59900e50082_9366/busenitz-pro-shoes.jpg", company: .Adidas, gender: .MAN, color: .Black, category: .Sneakers, condition: .NEW, size: 9, price: 120.00),
        Product(id: 4, name: "Adidas", description: "https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/00097f2522784e6d96b0aba400aa87a1_9366/Daily_3.0_Shoes_Grey_FW3270_01_standard.jpg", company: .Adidas, gender: .MAN, color: .Black, category: .Sneakers, condition: .NEW, size: 9, price: 60.00),
        Product(id: 5, name: "Adidas", description: "https://myreact.ru/wp-content/uploads/2023/02/ultra_4dfwd_shoes_black_gx6632_04_standard.jpg", company: .Adidas, gender: .MAN, color: .Black, category: .Sneakers, condition: .NEW, size: 9, price: 120.00),
        Product(id: 6, name: "Adidas", description: "https://myreact.ru/wp-content/uploads/2023/02/adidas_4dfwd_shoes_orange_gx2978_01_standard.jpg", company: .Adidas, gender: .MAN, color: .Black, category: .Sneakers, condition: .NEW, size: 9, price: 120.00),
    ]
    
    static let shared: MockCartService = .init()
    
    func getProducts() throws -> [Product] {
            return products
    }
    
    func deleteByID(id: Int) {
        products.remove(at: id)
    }
}
