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
        let image = UIImage(systemName: "cart")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "cart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        cartController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        let presenter = CartPresenter()
        cartController.presenter = presenter
        presenter.view = cartController
        return cartController
    }
    
}
