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
    
}
