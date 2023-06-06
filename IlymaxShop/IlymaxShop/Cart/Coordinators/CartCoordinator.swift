//
//  CartCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit



class CartCoordinator {
    
    private weak var navigationController: UINavigationController!

    func start() -> UIViewController {
        let cartController = CartViewController()
        let presenter = CartPresenter()
        presenter.pushShoe = pushShoeView
        cartController.presenter = presenter
        presenter.view = cartController
        let navigationController = UINavigationController(rootViewController: cartController)
        self.navigationController = navigationController
        return navigationController
    }
    
    func pushShoeView(shoe: Shoes) {
        let shoeViewCoordinator = ShoeViewCoordinator(navigationController: navigationController)
        shoeViewCoordinator.start(product: shoe)
    }
}
