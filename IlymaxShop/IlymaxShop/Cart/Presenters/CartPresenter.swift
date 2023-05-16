//
//  CartPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import FirebaseAuth
import UIKit

class CartPresenter {
    
    weak var view: CartViewController?
    private let cartService = CartService()
    public var pushShoe: (Shoes) -> Void = {_ in }
    
    func loadProducts() {
        cartService.getProducts(userID: FirebaseAuth.Auth.auth().currentUser!.uid) { [weak self] products in
            DispatchQueue.main.async {
                self?.view?.products = products
                self?.view?.hideLoader()
                self?.view?.updateView()
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
    func didTapOnSection(product: IlymaxCartItem){
        cartService.getShoe(shoeId: product.id) { [weak self] shoe in
            DispatchQueue.main.async {
                self?.view?.hideLoader()
                self?.pushShoe(shoe)
            }
        }
    }
    
    // MARK: - Удаление
    func delete(productId: String, size: String){
        cartService.delete(userID: FirebaseAuth.Auth.auth().currentUser!.uid, itemId: productId, size: size)
    }
}
