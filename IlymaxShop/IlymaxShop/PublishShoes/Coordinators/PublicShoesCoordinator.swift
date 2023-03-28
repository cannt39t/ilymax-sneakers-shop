//
//  PublicShoesCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class PublicShoesCoordinator {
    
    func start() -> UIViewController {
        let publicShoesController = PublicShoesViewController()
        let image = UIImage(systemName: "plus.app")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "plus.app")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        publicShoesController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return publicShoesController
    }
    
}
