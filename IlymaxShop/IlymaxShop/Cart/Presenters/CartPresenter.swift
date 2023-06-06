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
        cartService.getDefaultAddress { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let addressOptional):
                    guard let address = addressOptional else {
                        self?.view?.showAlertNoAddress()
                        return
                    }
                    self?.cartService.createOrder(items: self?.view?.products ?? [], address: address) { didCreate in
                        if didCreate {
                            self?.cartService.deleteCart { didDelete in
                                if didDelete {
                                    self?.view?.showOrderCreated()
                                }
                            }
                        } else {
                            print("Does not create order")
                        }
                    }
            }
        }
    }
    
    // MARK: - Открытие экрана товара
    func didTapOnSection(product: IlymaxCartItem){
        cartService.getShoe(shoeId: product.id) { [weak self] shoe, error in
            DispatchQueue.main.async { [weak self] in
                self?.view?.hideLoader()
                if let error {
                    print(error.localizedDescription)
                    return
                }
            
                guard let shoe = shoe else {
                    fatalError()
                }
                
                self?.pushShoe(shoe)
            }
        }
    }
    
    // MARK: - Удаление
    func delete(productId: String, size: String){
        cartService.delete(userID: FirebaseAuth.Auth.auth().currentUser!.uid, itemId: productId, size: size)
    }
}
