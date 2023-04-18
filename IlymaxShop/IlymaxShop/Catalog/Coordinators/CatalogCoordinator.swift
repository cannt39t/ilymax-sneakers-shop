//
//  CatalogCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class CatalogCoordinator {
    
    func start() -> UIViewController {
        let catalogController = CatalogViewController()
        let catalogPresenter = CatalogPresenter()
        catalogPresenter.view = catalogController
        catalogController.presenter = catalogPresenter
        return catalogController
    }
    
    private weak var navigationController: UINavigationController!
        
    func pushShoeView(shoe: Shoes) {
        let shoeViewController = ShoeViewController()
        let presenter = ShoeViewPresenter()
        shoeViewController.presenter = presenter
        presenter.view = shoeViewController
        presenter.product = shoe
        let navigationController = UINavigationController(rootViewController: shoeViewController)
        self.navigationController = navigationController
        return navigationController
    }
}
