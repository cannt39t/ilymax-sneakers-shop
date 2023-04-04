//
//  PublicShoesPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 04.04.2023.
//

import Foundation
import FirebaseAuth

class PublicShoesPresenter {
    weak var view: PublicShoesViewController?
    var coordinator: PublicShoesCoordinator!
    
    var product: Shoes = Shoes(name: "", description: "", color: "", gender: "", condition: "", imageUrl: "", data: [], ownerId: FirebaseAuth.Auth.auth().currentUser!.uid, company: "", category: "")
    
    
}
