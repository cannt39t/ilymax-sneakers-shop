//
//  CatalogCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class CatalogCoordinator {
    
    func start() -> UIViewController {
        let cartController = CartViewController()
        let image = UIImage(systemName: "house")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "house")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        cartController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return cartController
    }
    
}
