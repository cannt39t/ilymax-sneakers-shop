//
//  SellerViewPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 17.05.2023.
//

import UIKit


class SellerViewPresenter {
    
    weak var view: SellerViewViewController?
    var products: [Shoes] = []
    var user: IlymaxUser!
    public var pushShoe: (Shoes) -> () = { _ in }
     
}
