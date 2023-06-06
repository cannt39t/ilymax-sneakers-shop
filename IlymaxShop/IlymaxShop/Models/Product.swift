//
//  Product.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import UIKit

enum Gender: String {
    case MAN
    case WOMAN
}

enum Color: String {
    case Black
    case Blue
    case Brown
    case Gold
    case Green
    case Grey
    case Multi
    case Navy
    case Neutral
    case Orange
    case Pink
    case Purple
    case Red
    case Silver
    case White
    case Yellow
}

enum Category: String {
    case Boat_Shoes
    case Boots
    case Clogs
    case Espadrilles
    case Flip_Flops
    case Sandals
    case Shoes
    case Slippers
    case Sneakers
    case Accessories
}

enum Condition: String {
    case NEW
    case PiU
}

enum Company: String {
    case ILYMAX
    case Nike
    case Adidas
    case Vans
    case Timberland
    case Puma
    case Crocs
    case Reebok
    case Converse
    case Lacoste
    case Jordan
    case Barbour
    case TODS
    case Brioni
    case Gucci
    case Diesel
    case NB
    case Diadora
    case DrMartens
    case Asics
    case Boss
    case Salomon
    case UGG
}

struct Product {
    let id: Int
    let name: String
    let description: String
    let company: Company
    let gender: Gender
    let color: Color
    let category: Category
    let condition: Condition
    let size: Int
    let price: Double
}
