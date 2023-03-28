//
//  TabBarCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class TabBarCoordinator {
    
    weak var tabBarController: UITabBarController?
    
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        tabBarController.viewControllers = [catalog(), cart(), publicShoes(), chat(), profile()]
        tabBarController.tabBar.backgroundColor = .white
        return tabBarController
    }
    
    func catalog() -> UIViewController {
        let catalogCoordinator = CatalogCoordinator()
        let catalogController = catalogCoordinator.start()
        let image = UIImage(systemName: "house")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "house")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        catalogController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return catalogController
    }
    
    func cart() -> UIViewController {
        let cartCoordinator = CartCoordinator()
        return cartCoordinator.start()
    }
    
    func publicShoes() -> UIViewController {
        let publicShoesCoordinator = PublicShoesCoordinator()
        return publicShoesCoordinator.start()
    }
    
    func chat() -> UIViewController {
        let chatCoordinator = ChatCoordinator()
        return chatCoordinator.start()
    }
    
    func profile() -> UIViewController {
//        if authorized then profile else signincorrdinator
//        let profileCoordinator = ProfileCoordinator()
//        return profileCoordinator.start()
        let image = UIImage(systemName: "person")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "person")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let authCoordinator = AuthenticationCoordinator()
        let controller = authCoordinator.start()
        controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return controller
    }
    
}
