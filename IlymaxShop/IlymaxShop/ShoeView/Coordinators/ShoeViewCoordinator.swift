//
//  ShoeViewCoordinator.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

class ShoeViewCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    func start() -> UIViewController {
        let shoeViewController = ShoeViewController()
        let presenter = ShoeViewPresenter()
        shoeViewController.presenter = presenter
        presenter.view = shoeViewController
//        FirestoreManager.shared.getShoe(withId: "gXA8ram09IKvhq8KucNL") { (shoe, error) in
//            if let error = error {
//                print("Error getting shoe: \(error.localizedDescription)")
//                return
//            }
//
//            guard let shoe = shoe else {
//                print("Shoe not found")
//                return
//            }
//            print(shoe.name)
//            presenter.product = shoe
//        }
        
        FirestoreManager.shared.getAllShoes{ (shoe, error) in
            if let error = error {
                print("Error getting shoe: \(error.localizedDescription)")
                return
            }

            guard let shoe = shoe else {
                print("Shoe not found")
                return
            }
            presenter.product = shoe[6]
        }

        let navigationController = UINavigationController(rootViewController: shoeViewController)
        self.navigationController = navigationController
        return navigationController
    }
    
}
