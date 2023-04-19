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
        catalogPresenter.pushListShoes = pushListOfShoes
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
    
    func pushListOfShoes(shoes: [Shoes]) {
        let listOfShoesController = ProductListViewController()
        let presenter = ProductListPresenter()
        presenter.pushShoe = pushShoeView
        presenter.presentMoodal = presentModalAdding
        listOfShoesController.presenter = presenter
        presenter.products = shoes
        presenter.view = listOfShoesController
        navigationController.pushViewController(listOfShoesController, animated: true)
    }
    
    func presentModalAdding(shoes: Shoes){
        let modalAddingViewController = ModalAddingViewController()
        let presenter = ProductListPresenter()
        modalAddingViewController.presenter = presenter
        modalAddingViewController.product = shoes
        navigationController?.present(modalAddingViewController, animated: true)
    }
}
