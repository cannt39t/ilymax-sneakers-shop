//
//  CartCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit



class CartCoordinator {
        
    func start() -> UIViewController {
        let cartController = CartViewController()
        let presenter = CartPresenter()
        cartController.presenter = presenter
        presenter.view = cartController
        return cartController
    }
    
}
