//
//  FirebasePublicShoesService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 04.04.2023.
//

import Foundation
import UIKit

class FirebasePublicShoesService: PublicShoesService {
    
    func insertShoes(with shoes: Shoes, image: UIImage) {
        FirestoreManager.shared.insertShoes(with: shoes, image: image)
    }
    
    func getCategiriesString(completion: @escaping (([String]) -> Void)) {
        FirestoreManager.shared.getAllCategoriesStrings { categories in
            completion(categories)
        }
    }
}
