//
//  CartService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import Foundation
import Combine

protocol CartService {
    func getProducts() throws -> [Product]
    func deleteByID(id: Int)
}
