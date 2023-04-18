//
//  CatalogCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class CatalogCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    func start() -> UIViewController {
        let catalogController = CatalogViewController()
        let catalogPresenter = CatalogPresenter()
        catalogPresenter.pushShoe = pushShoeView
        catalogPresenter.view = catalogController
        catalogController.presenter = catalogPresenter
        let navigationController = UINavigationController(rootViewController: catalogController)
        self.navigationController = navigationController
        return navigationController
    }
        
    func pushShoeView(shoe: Shoes) {
        let shoeViewController = ShoeViewController()
        let presenter = ShoeViewPresenter()
        shoeViewController.presenter = presenter
        presenter.view = shoeViewController
        presenter.product = shoe
        navigationController.pushViewController(shoeViewController, animated: true)
    }
}
