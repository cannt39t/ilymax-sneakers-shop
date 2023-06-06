//
//  PublicShoesCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class PublicShoesCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    func start() -> UIViewController {
        let publicShoesController = PublicShoesViewController()
        let publicShoesPresenter = PublicShoesPresenter()
        publicShoesController.presenter = publicShoesPresenter
        publicShoesPresenter.view = publicShoesController
        publicShoesPresenter.coordinator = self
        FirestoreManager.shared.getAllCategoriesStrings{categories in
            publicShoesPresenter.categories = categories
        }
        let navigationController = UINavigationController(rootViewController: publicShoesController)
        self.navigationController = navigationController
        return navigationController
    }
    
}
