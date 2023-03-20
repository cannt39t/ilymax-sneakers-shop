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
        return catalogCoordinator.start()
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
        let profileCoordinator = ProfileCoordinator()
        return profileCoordinator.start()
    }
    
}
