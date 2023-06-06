//
//  ProductListPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import FirebaseAuth
import UIKit

protocol ProductListPresenterDelegate: AnyObject {
    func showInfo(product: Shoes)
    func modalAdding(product: Shoes)
    func addToCart(ilymaxCartItem: IlymaxCartItem)
    
}

class ProductListPresenter {
    private let service = ListOfProductsService()
    var navigationController: UINavigationController?
    weak var view: ProductListViewController?
    var products: [Shoes] = []
    var name: String = ""
    var searchStr: String = ""
    public var pushShoe: (Shoes) -> Void = {_ in }
    public var presentMoodal: (Shoes) -> Void = {_ in }
}

extension ProductListPresenter: ProductListPresenterDelegate {
    
    //MARK: -Добавление в корзину
    func addToCart(ilymaxCartItem: IlymaxCartItem) {
        service.addItemToCart(userID: FirebaseAuth.Auth.auth().currentUser!.uid, item: ilymaxCartItem)
    }
    
    
    func modalAdding(product: Shoes) {
        presentMoodal(product)
    }
    
    // MARK: - Открытие экрана товара
    func showInfo(product: Shoes) {
        pushShoe(product)
        print("PRESENTER")
    }
    
    func sortShoes(sortOption: String, selectedGender: String, selectedSize: String, selectedColor: String, selectedBrand: String, selectedCondition: String) {
        view?.showLoader()
//        print("Selected Sort Option: \(sortOption )")
//        print("Selected Gender: \(selectedGender )")
//        print("Selected Size: " + String(selectedSize))
//        print("Selected Color: \(selectedColor )")
//        print("Selected Brand: \(selectedBrand )")
//        print("Selected Condition: \(selectedCondition )")
        var category = "None"
        if searchStr == "None" {
            category = name
        }
        service.getAllFilterShoes(searchStr: searchStr, selectedGender: selectedGender.uppercased(), selectedColor: selectedColor, selectedBrand: selectedBrand, selectedCondition: selectedCondition, selectedCategory : category) { [weak self] products, error  in
            var resultShoes = products
            if selectedSize != "None" {
                var index = -1
                for product in products ?? [] {
                    index += 1
                    var count = 0
                    for data in product.data {
                        if String(data.size) == "\(selectedSize) EU"{
                            count += 1
                        }
                    }
                    if count == 0 {
                        resultShoes?.remove(at: index)
                        index -= 1
                    }
                }
            }
            
            if sortOption != "None" {
                if sortOption == "Price High to Low" {
                    resultShoes?.sort { $0.data.first?.price ?? 0 > $1.data.first?.price ?? 0 }
                } else {
                    resultShoes?.sort { $0.data.first?.price ?? 0 < $1.data.first?.price ?? 0 }
                }
            }
            DispatchQueue.main.async {
                self?.products = resultShoes ?? []
                self?.view?.isEmpty()
                self?.view?.collectionView.reloadData()
                self?.view?.hideLoader()
            }
        }
    }
}
