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
        let image = UIImage(systemName: "cart")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "cart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
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
        let image = UIImage(systemName: "plus.app")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "plus.app")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let controller = NoAuthViewController()
            controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return controller
        } else {
            let publicShoesCoordinator = PublicShoesCoordinator()
            let publicShoesController = publicShoesCoordinator.start()
            publicShoesController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return publicShoesController
        }
    }
    
    func chat() -> UIViewController {
        let image = UIImage(systemName: "message.badge")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "message.badge")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let controller = NoAuthViewController()
            controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return controller
        } else {
            let chatCoordinator = ChatCoordinator()
            let chatController = chatCoordinator.start()
            chatController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
            
            return chatController
        }
    }
    
    func profile() -> UIViewController {
        let image = UIImage(systemName: "person")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "person")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    
        let controller = validateAuth()
        controller.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        
        return controller
    }
    
    private func validateAuth() -> UIViewController {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let authCoordinator = AuthenticationCoordinator()
            authCoordinator.startProfile = replaceAuthByProfile
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
        let image = UIImage(named: "Welcome")!
        let shoes = Shoes(name: "Sneakers", description: "Comfortable sneakers", color: "White", gender: "Unisex", imageUrl: nil, data: [ShoesDetail(size: "US 7", price: 99.99, quantity: 10), ShoesDetail(size: "US 8", price: 89, quantity: 5)], ownerId: "123", company: "Nike", category: "Athletic")

        print(shoes.lowestPrice)
    }
    
//    private func test() {
//        FirestoreManager.shared.getAllPromotions { promotions in
//            print("here")
//            for promotion in promotions {
//                print(promotion)
//            }
//        }
//    }
}
