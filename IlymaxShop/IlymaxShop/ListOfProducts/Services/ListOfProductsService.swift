//
//  ListOfProductsService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 30.04.2023.
//

import Foundation

class ListOfProductsService {
    func getAllFilterShoes(selectedGender: String, selectedColor: String, selectedBrand: String, selectedCondition: String, completion: @escaping ([Shoes]?, Error?) -> Void) {
        FirestoreManager.shared.getAllFilterShoes(selectedGender: selectedGender, selectedColor: selectedColor, selectedBrand: selectedBrand, selectedCondition: selectedCondition){ shoes, error in
            if let error {
                print(error)
                completion([], error)
                return
            }
            completion(shoes ?? [], error)
        }
    }
}
