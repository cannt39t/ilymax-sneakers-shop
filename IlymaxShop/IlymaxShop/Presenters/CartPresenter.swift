//
//  CartPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import UIKit

protocol CartPresenterDelegate: AnyObject {
    func deleteByID(productId: Int)
}

class CartPresenter {
    
    weak var view: CartViewController?
    var products: [Product] = []
        
    private let cartService = MockCartService.shared
    
    func getProducts() {
        do{
            products = try cartService.getProducts()
        }catch{
            print(error)
        }
    }
    
    // MARK: - Переадресация на платежку
    func buyButtonDidTap() {
        if let url = URL(string: "https://qiwi.com/n/MAKSYAK") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Открытие экрана товара
    func didTapOnSection(productId: Int){
        
    }
    
}

extension CartPresenter: CartPresenterDelegate {
    // MARK: - Удаление
    func deleteByID(productId: Int){
        let id = products.firstIndex(where: { $0.id == productId })
        cartService.deleteByID(id: id!)
        getProducts()
        view?.updateView()
    }
}
