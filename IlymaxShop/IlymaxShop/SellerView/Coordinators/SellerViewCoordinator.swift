//
//  SellerViewCoordinator.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.05.2023.
//

import UIKit

class SellerViewCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start(products: [Shoes], user: IlymaxUser) {
        let sellerViewViewController = SellerViewViewController()
        let presenter = SellerViewPresenter()
        sellerViewViewController.presenter = presenter
        presenter.pushShoe = pushShoeView
        presenter.products = products
        presenter.user = user
        presenter.view = sellerViewViewController
        navigationController.pushViewController(sellerViewViewController, animated: true)
    }
    
    func pushShoeView(shoe: Shoes) {
        let shoeViewCoordinator = ShoeViewCoordinator(navigationController: navigationController)
        shoeViewCoordinator.start(product: shoe)
    }
}
