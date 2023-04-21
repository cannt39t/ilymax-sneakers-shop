//
//  CartPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import UIKit

class CartPresenter {
    
    weak var view: CartViewController?
    private let cartService = CartService()
    public var pushShoe: (Shoes) -> Void = {_ in }
    
    public func fetchData() {
        let group = DispatchGroup()

        group.enter()
        loadProducts(group: group)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.updateView()
        }
    }
    
    func loadProducts(group: DispatchGroup) {
        cartService.getProducts { [weak self] products in
            DispatchQueue.main.async {
                self?.view?.products = products
                group.leave()
            }
        }
    }
    
    // MARK: - Переадресация на платежку
    func buyButtonDidTap() {
        if let url = URL(string: "https://qiwi.com/n/MAKSYAK") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Открытие экрана товара
    func didTapOnSection(product: Shoes){
        pushShoe(product)
    }
    
    // MARK: - Удаление
    func deleteByID(productId: String){
        cartService.deleteByID(id: productId)
    }
}
