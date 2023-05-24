//
//  TabBarCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit
import FirebaseAuth

class TabBarCoordinator {
    
    weak var tabBarController: UITabBarController?
    
    func start() -> UIViewController {
        
        test()
        
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        tabBarController.viewControllers = [catalog(), cart(), publicShoes(), chat(), profile()]
        tabBarController.tabBar.backgroundColor = .systemBackground
    
        Auth.auth().addStateDidChangeListener() { [self] auth, user in
            self.replaceAuthByProfile()
        }
        
        return tabBarController
    }
    
    func catalog() -> UIViewController {
        let catalogCoordinator = CatalogCoordinator()
        let catalogController = catalogCoordinator.start()
        let image = UIImage(systemName: "house")?.withTintColor(.tertiarySystemBackground)
        let selectedImage = UIImage(systemName: "house")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        catalogController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return catalogController
    }
    
    func cart() -> UIViewController {
        let image = UIImage(systemName: "cart")?.withTintColor(.tertiarySystemBackground)
        let selectedImage = UIImage(systemName: "cart")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let controller = NoAuthViewController()
            controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return controller
        } else {
            let cartCoordinator = CartCoordinator()
            let cartController = cartCoordinator.start()
            cartController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return cartController
        }
    }
    
    func publicShoes() -> UIViewController {
        let originalImage = UIImage(systemName: "plus.circle.fill")
        let imageSize = CGSize(width: 50, height: 50)
        let resizedImage = originalImage?.resizedImage(targetSize: imageSize)?.withTintColor(.label, renderingMode: .alwaysOriginal)

        let tabBarItem = UITabBarItem(title: "", image: resizedImage, selectedImage: resizedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: -7, left: 0, bottom: 7, right: 0)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let controller = NoAuthViewController()
            controller.tabBarItem = tabBarItem
            return controller
        } else {
            let publicShoesCoordinator = PublicShoesCoordinator()
            let publicShoesController = publicShoesCoordinator.start()
            publicShoesController.tabBarItem = tabBarItem
            return publicShoesController
        }
    }


    
    func chat() -> UIViewController {
        let image = UIImage(systemName: "message.badge")?.withTintColor(.tertiarySystemBackground)
        let selectedImage = UIImage(systemName: "message.badge")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let controller = NoAuthViewController()
            controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return controller
        } else {
            let conversationsCoordinator = ConversationsCoordinator()
            let conversationsController = conversationsCoordinator.start()
            conversationsController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return conversationsController
        }
    }
    
    func profile() -> UIViewController {
        let image = UIImage(systemName: "person")?.withTintColor(.tertiarySystemBackground)
        let selectedImage = UIImage(systemName: "person")?.withTintColor(.label, renderingMode: .alwaysOriginal)
    
        let controller = validateAuth()
        controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        
        return controller
    }
    
    private func validateAuth() -> UIViewController {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let authCoordinator = AuthenticationCoordinator()
            let controller = authCoordinator.start()
            return controller
        } else {
            let profileCoordinator = ProfileCoordinator()
            let controller = profileCoordinator.startProfile()
            return controller
        }
    }
    
    func replaceAuthByProfile() {
        var arrayOfControllers = tabBarController?.viewControllers
        arrayOfControllers?[1] = cart()
        arrayOfControllers?[2] = publicShoes()
        arrayOfControllers?[3] = chat()
        arrayOfControllers?[4] = profile()
        tabBarController?.viewControllers = arrayOfControllers
    }
    
    private func test() {
//        fatalError("Test")
    }
}
