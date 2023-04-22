//
//  ProductListPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

protocol ProductListPresenterDelegate: AnyObject {
    func showInfo(product: Shoes)
    func modalAdding(product: Shoes)
    func addToCart(productId: String)
    
}

class ProductListPresenter {
    var navigationController: UINavigationController?
    weak var view: ProductListViewController?
    var products: [Shoes] = []
    public var pushShoe: (Shoes) -> Void = {_ in }
    public var presentMoodal: (Shoes) -> Void = {_ in }
}

extension ProductListPresenter: ProductListPresenterDelegate {
    
    //MARK: -Добавление в корзину
    func addToCart(productId: String) {
        print("PRESENTER AddingToCart")
    }
    
    
    func modalAdding(product: Shoes) {
        presentMoodal(product)
    }
    
    // MARK: - Открытие экрана товара
    func showInfo(product: Shoes) {
        pushShoe(product)
        print("PRESENTER")
    }
}
