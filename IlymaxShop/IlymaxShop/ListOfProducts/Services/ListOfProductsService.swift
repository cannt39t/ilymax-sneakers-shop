//
//  ListOfProductsService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 30.04.2023.
//

import Foundation

class ListOfProductsService {
    func getAllFilterShoes(searchStr: String, selectedGender: String, selectedColor: String, selectedBrand: String, selectedCondition: String, selectedCategory: String, completion: @escaping ([Shoes]?, Error?) -> Void) {
        FirestoreManager.shared.getAllFilterShoes(searchStr: searchStr, selectedGender: selectedGender, selectedColor: selectedColor, selectedBrand: selectedBrand, selectedCondition: selectedCondition, selectedCategory: selectedCategory){ shoes, error in
            if let error {
                print(error)
                completion([], error)
                return
            }
            completion(shoes ?? [], error)
        }
    }
    
    func addItemToCart(userID: String, item: IlymaxCartItem) {
        FirestoreManager.shared.addItemToCart(userID: userID, item: item) { success in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
}
