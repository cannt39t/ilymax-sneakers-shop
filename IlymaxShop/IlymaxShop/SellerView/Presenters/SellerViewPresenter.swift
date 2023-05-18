//
//  SellerViewPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 17.05.2023.
//

import UIKit

protocol SellerViewPresenterDelegate: AnyObject {
    func showInfo(product: Shoes)    
}
class SellerViewPresenter {
    
    weak var view: SellerViewViewController?
    var products: [Shoes] = []
    var user: IlymaxUser?
    public var pushShoe: (Shoes) -> Void = {_ in }
}

extension SellerViewPresenter: SellerViewPresenterDelegate {
    // MARK: - Открытие экрана товара
    func showInfo(product: Shoes) {
        pushShoe(product)
    }
}
