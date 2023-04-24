//
//  PublicShoesPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 04.04.2023.
//

import FirebaseAuth
import UIKit

class PublicShoesPresenter {
    weak var view: PublicShoesViewController?
    var coordinator: PublicShoesCoordinator!
    private var publicShoesService: PublicShoesService = FirebasePublicShoesService()
    
    var product: Shoes = Shoes(name: "", description: "", color: "", gender: "", condition: "", imageUrl: "", data: [], ownerId: FirebaseAuth.Auth.auth().currentUser!.uid, company: "", category: "")
    
    func addToDB(with shoes: Shoes, image: UIImage){
        publicShoesService.insertShoes(with: shoes, image: image)
    }
    
    func restart() {
        product = Shoes(name: "", description: "", color: "", gender: "", condition: "", imageUrl: "", data: [], ownerId: FirebaseAuth.Auth.auth().currentUser!.uid, company: "", category: "")
        self.view?.updateData()
    }
    
    var categories: [String] = [""]
}
