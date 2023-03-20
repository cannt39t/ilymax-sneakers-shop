//
//  ChatCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class ChatCoordinator {
    
    func start() -> UIViewController {
        let chatController = ChatViewController()
        let image = UIImage(systemName: "message.badge")?.withTintColor(.gray)
        let selectedImage = UIImage(systemName: "message.badge")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        chatController.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return chatController
    }
    
}
