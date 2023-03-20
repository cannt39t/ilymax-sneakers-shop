//
//  ProfileCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class ProfileCoordinator {
    
    func start() -> UIViewController {
        let profileController = ProfileViewController()
        let image = UIImage(systemName: "person")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "person")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        profileController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return profileController
    }
    
}
