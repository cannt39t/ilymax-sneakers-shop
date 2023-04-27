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
        let shoeViewCoordinator = ShoeViewCoordinator(navigationController: navigationController)
        shoeViewCoordinator.start(product: shoe)
    }
    
    func pushListOfShoes(shoes: [Shoes], name: String) {
        let listOfShoesController = ProductListViewController()
        let presenter = ProductListPresenter()
        presenter.pushShoe = pushShoeView
        presenter.presentMoodal = presentModalAdding
        listOfShoesController.presenter = presenter
        presenter.products = shoes
        presenter.name = name
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
